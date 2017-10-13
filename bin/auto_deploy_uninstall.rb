#!/usr/bin/env ruby

USER_DIRECTORY = `cd ~; pwd`.chomp.freeze
PATH_TO_LAUNCH_LIB = (USER_DIRECTORY + "/Library/LaunchAgents").freeze
PATH_TO_LAUNCH_PROGRAM = (PATH_TO_LAUNCH_LIB + "/auto_deploy.rb").freeze
PATH_TO_LAUNCH_PLIST = (PATH_TO_LAUNCH_LIB + "/com.toptutoring.auto.deploy.plist").freeze

def display(message)
  STDOUT.puts message
end

def shell_success?
  $?.exitstatus == 0
end

def installed?
  File.exists?(PATH_TO_LAUNCH_PLIST) ||
    File.exists?(PATH_TO_LAUNCH_PROGRAM) ||
    loaded?
end

def loaded?
  !`launchctl list | grep com\.toptutoring\.auto\.deploy`.empty?
end

def unload_message
  if shell_success? && !loaded?
    display "Successfully unloaded #{PATH_TO_LAUNCH_PLIST}."
  else
    display "Failure! Was unable to unload #{PATH_TO_LAUNCH_PLIST} from launchctl. Please check manually."
  end
end

def unload_program
  if loaded?
    display "Proceeding to unload program from launchctl."
    `launchctl unload #{PATH_TO_LAUNCH_PLIST}`
    unload_message
  else
    display "Program not loaded. Skipping step."
  end
end

def remove_files
  display "Proceeding to remove files."
  `rm #{PATH_TO_LAUNCH_PLIST} #{PATH_TO_LAUNCH_PROGRAM}`
  if shell_success?
    display "Successfully removed #{PATH_TO_LAUNCH_PLIST} and #{PATH_TO_LAUNCH_PROGRAM}"
  else
    display "Failure! Unable to remove #{PATH_TO_LAUNCH_PLIST} and #{PATH_TO_LAUNCH_PROGRAM}. Please check the #{PATH_TO_LAUNCH_LIB} directory to see if these files are present."
  end
end

if installed?
  unload_program
  remove_files
else
  display "Nothing to uninstall."
end

display "Uninstall auto_deploy has finished running."
