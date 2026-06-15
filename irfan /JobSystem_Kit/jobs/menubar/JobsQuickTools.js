// Jobs Quick Tools — separate mini menubar for two actions
ObjC.import('Cocoa');
ObjC.import('AppKit');

function run() {
  const app = Application.currentApplication();
  app.includeStandardAdditions = true;

  const menubar = $.NSStatusBar.systemStatusBar;
  const item = menubar.statusItemWithLength($.NSVariableStatusItemLength);
  item.button.title = "📨 Jobs";
  item.button.toolTip = "Jobs Quick Tools";

  const menu = $.NSMenu.alloc.init;

  function addMenuItem(title, handler) {
    const mi = $.NSMenuItem.alloc.initWithTitleActionKeyEquivalent($(title), 'callAction:', '');
    mi.setTarget(ActionHandler.alloc.init(handler));
    menu.addItem(mi);
  }

  // Action Handler class to bridge to JS functions
  const ActionHandler = ObjC.registerSubclass({
    name: 'ActionHandler',
    superClasses: ['NSObject'],
    methods: {
      'init:': function(handler) {
        this = this.super.init();
        this._handler = handler;
        return this;
      },
      'callAction:': function() {
        this._handler();
      }
    }
  });

  function shell(cmd) {
    try {
      return app.doShellScript(cmd);
    } catch (e) {
      return "ERROR: " + e.toString();
    }
  }

  // 1) Force Apply 200 Now
  addMenuItem("Force Apply 200 Now", function() {
    const out = shell("~/jobs/menubar/force_apply.sh");
    app.displayNotification("Force Apply triggered", { withTitle: "Jobs Quick Tools" });
  });

  // 2) Health Check (Status)
  addMenuItem("Health Check (Status)", function() {
    const result = shell("~/jobs/menubar/health_check.sh");
    app.displayDialog(result, { withTitle: "Job System Health" });
  });

  // Quit
  menu.addItem($.NSMenuItem.separatorItem);
  addMenuItem("Quit Jobs Quick Tools", function() {
    $.NSApp.terminate(nil);
  });

  item.menu = menu;
  $.NSApplication.sharedApplication.run();
}
