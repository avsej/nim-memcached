import nake, os

const privateTasks = [defaultTask]
nake.listTasks = proc() =
  echo "Available tasks:"
  for name, task in nake.tasks:
    if name in privateTasks:
      continue
    echo name, "\t # ", task.desc


task "test", "runs all tests":
  var files = ["netdef.nim", "memcacheasync.nim"]
  for file in files:
    var exe = file.changeFileExt(ExeExt)
    if exe.needsRefresh(file):
      direShell(nimExe, "compile", "-d:testing", file)
  var failed = 0
  for file in files:
    if not shell("." / file.changeFileExt(ExeExt)):
      failed += 1
  if failed > 0:
    quit(QuitFailure)

task defaultTask, "":
  runTask("test")
