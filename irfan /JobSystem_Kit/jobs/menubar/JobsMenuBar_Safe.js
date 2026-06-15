ObjC.import('Cocoa');

const app = Application.currentApplication();
app.includeStandardAdditions = true;

// Initialize NSApplication and set accessory (menubar-only) policy
$.NSApplication.sharedApplication();
$.NSApp.setActivationPolicy($.NSApplicationActivationPolicyAccessory);

// Create a status item and its menu
const statusItem = $.NSStatusBar.systemStatusBar.statusItemWithLength($.NSVariableStatusItemLength);
const menu = $.NSMenu.alloc.init();

// Helper to set title safely
function setTitle() {
  const btn = statusItem.button;    // Ensure button exists (early init can be nil)
  if (btn) btn.setTitle("Jobs: Ready");
}

// Define an Objective‑C class to receive menu actions
const HandlerClass = $.NSObject.extend({
  'openDash:': function() {
    try { app.doShellScript('open -a Terminal "$HOME/Applications/Jobs Dashboard.app"'); } catch (e) {}
  },
  'refreshNow:': function() {
    try { setTitle(); } catch (e) {}
  },
  'exportWeekly:': function() {
    try { app.doShellScript('bash "$HOME/jobs/bin/jobdash" --export-weekly'); } catch (e) {}
  },

  // NEW: Force Apply 200 Now
  'forceApply:': function() {
    try {
      app.doShellScript('~/jobs/menubar/force_apply.sh');
      app.displayNotification("Force Apply triggered", { withTitle: "Jobs Menu" });
    } catch (e) {
      app.displayDialog("Force Apply error:\n" + e.toString(), { withTitle: "Jobs Menu" });
    }
  },

  // NEW: Health Check status dialog
  'healthCheck:': function() {
    try {
      const result = app.doShellScript('~/jobs/menubar/health_check.sh');
      app.displayDialog(result, { withTitle: "Job System Health" });
    } catch (e) {
      app.displayDialog("Health Check error:\n" + e.toString(), { withTitle: "Jobs Menu" });
    }
  },

  'quitApp:': function() {
    $.NSApp.terminate($.nil);
  }
}, { name: 'JobsMenuHandler', methods: [
  'openDash:', 'refreshNow:', 'exportWeekly:', 'forceApply:', 'healthCheck:', 'quitApp:'
]});

const handler = HandlerClass.alloc.init();

// Utility to add menu items
function addItem(title, selectorName) {
  const sel  = ObjC.selector(selectorName);
  const item = $.NSMenuItem.alloc.initWithTitleActionKeyEquivalent($(title), sel, $(''));
  item.setTarget(handler);
  menu.addItem(item);
}

// Build the menu
addItem('Open Dashboard',     'openDash:');
addItem('Refresh Now',        'refreshNow:');
addItem('Export weekly CSV',  'exportWeekly:');

// NEW items
menu.addItem($.NSMenuItem.separatorItem);
addItem('Force Apply 200 Now',   'forceApply:');
addItem('Health Check (Status)', 'healthCheck:');

menu.addItem($.NSMenuItem.separatorItem);
addItem('Quit', 'quitApp:');

// Attach menu and set title
statusItem.setMenu(menu);
setTitle();

// Run the app
$.NSApp.run();
