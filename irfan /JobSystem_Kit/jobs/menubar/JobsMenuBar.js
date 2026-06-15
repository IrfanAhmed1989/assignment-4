// Jobs Menu Bar (stable, NO timer) — manual refresh only to avoid pop-ups
ObjC.import('Cocoa'); ObjC.import('Foundation');

const HOME = $.NSHomeDirectory().js;
const JOBS = HOME + '/jobs';
const LOG  = JOBS + '/logs';
const APPLIED = LOG + '/applied.csv';
const DASH_APP = HOME + '/Applications/Jobs Dashboard.app';

const app = $.NSApplication.sharedApplication;
app.setActivationPolicy($.NSApplicationActivationPolicyAccessory);

// ----- helpers -----
function readFile(path){
  const s = $.NSString.stringWithContentsOfFileEncodingError($(path), $.NSUTF8StringEncoding, null);
  return s ? ObjC.unwrap(s) : '';
}
function todayStr(){ const d = new Date(); return d.toISOString().slice(0,10); }
function dateMinus(days){ const d = new Date(); d.setDate(d.getDate()-days); return d.toISOString().slice(0,10); }

function parseApplied(){
  const txt = readFile(APPLIED);
  if (!txt) return [];
  return txt.split(/\r?\n/).filter(Boolean).map(l=>{
    const p=l.split(',');
    if (p.length<6) return null;
    return { date:(p[0]||'').trim() };
  }).filter(Boolean);
}

function counts(){
  try{
    const rows = parseApplied();
    const td = todayStr(), d7 = dateMinus(6);
    let today=0, last7=0;
    for(const r of rows){
      const only = (r.date||'').split(' ')[0];
      if(only===td) today++;
      if(only>=d7 && only<=td) last7++;
    }
    return { today, last7 };
  }catch(e){ return { today:0, last7:0 }; }
}

function setTitleNow(){
  const c = counts();
  statusItem.button.setTitle($( `Jobs: ${c.today} | ${c.last7}` ));
}

function shell(cmd){
  const t=$.NSTask.alloc.init; t.setLaunchPath($('/bin/zsh'));
  t.setArguments($( ['-lc', cmd] )); t.launch();
}

// ----- menubar + menu -----
const statusItem = $.NSStatusBar.systemStatusBar.statusItemWithLength($.NSVariableStatusItemLength);
const menu = $.NSMenu.alloc.init.autorelease();

ObjC.registerSubclass({
  name: 'JobsMenuHandler',
  methods: {
    'openDash:':   { types:['void',['id']], implementation:function(_){ shell(`open -a "${DASH_APP}"`); } },
    'refreshNow:': { types:['void',['id']], implementation:function(_){ try{ setTitleNow(); }catch(e){ $.NSBeep(); } } },
    'exportWeekly:': { types:['void',['id']], implementation:function(_){
      try{
        const txt = readFile(APPLIED); if(!txt){ $.NSBeep(); return; }
        const td=todayStr(), d7=dateMinus(6);
        const rows = txt.split(/\r?\n/).filter(Boolean).map(l=>l.split(',')).filter(a=>a.length>=6);
        const in7 = rows.filter(r=>{const d=(r[0]||'').split(' ')[0]; return (d>=d7 && d<=td);});
        const byDay={}; in7.forEach(r=>{const d=(r[0]||'').split(' ')[0]; byDay[d]=(byDay[d]||0)+1;});
        const out=[['section','key','value']]; Object.keys(byDay).sort().forEach(k=>out.push(['daily',k,String(byDay[k])]));
        const fn=`${LOG}/weekly_summary_${td.replace(/-/g,'')}.csv`;
        const csv=out.map(r=>r.join(',')).join('\n');
        $(csv).writeToFileAtomicallyEncodingError($(fn), true, $.NSUTF8StringEncoding, null);
        statusItem.button.setTitle($( "Jobs: Exported" )); // single update, no timers
      }catch(e){ $.NSBeep(); }
    }},
    'quitApp:': { types:['void',['id']], implementation:function(_){ $.NSApplication.sharedApplication.terminate(nil); } }
  }
});
const handler = $.JobsMenuHandler.alloc.init;

function addItem(title, sel){
  const it=$.NSMenuItem.alloc.initWithTitleActionKeyEquivalent($(title), ObjC.selector(sel), $(''));
  it.setTarget(handler); menu.addItem(it);
}
addItem('Open Dashboard', 'openDash:');
addItem('Refresh Now',   'refreshNow:');
addItem('Export weekly CSV', 'exportWeekly:');
menu.addItem($.NSMenuItem.separatorItem);
addItem('Quit', 'quitApp:');

statusItem.setMenu(menu);
setTitleNow();
app.run();
