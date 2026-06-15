on run
  set theCmd to "export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; printf '\\e[8;40;120t' 2>/dev/null; ~/jobs/bin/jobdash"
  tell application "Terminal"
    activate
    if (count of windows) is 0 then
      do script theCmd
    else
      do script theCmd in (do script "") -- new tab
    end if
    try
      set bounds of front window to {120, 80, 1200, 800} -- left, top, right, bottom
      set custom title of front window to "Jobs Dashboard — Irfan"
    end try
  end tell
end run
