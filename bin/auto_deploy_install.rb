#!/usr/bin/env ruby

USER_DIRECTORY = `cd ~; pwd`.chomp.freeze
PATH_TO_LAUNCH_LIB = (USER_DIRECTORY + "/Library/LaunchAgents").freeze
PATH_TO_LAUNCH_PROGRAM = (PATH_TO_LAUNCH_LIB + "/auto_deploy.rb").freeze
PATH_TO_LAUNCH_PLIST = (PATH_TO_LAUNCH_LIB + "/com.toptutoring.auto.deploy.plist").freeze
PATH_TO_DIRECTORY = `pwd`.chomp.freeze
PATH_TO_TTUTORING = PATH_TO_DIRECTORY.gsub("toptutoring", "ttutoring").freeze
PATH_TO_DEPLOY_PROGRAM = (PATH_TO_DIRECTORY + "/bin/auto_deploy.rb").freeze
PATH_TO_PLIST = (PATH_TO_DIRECTORY + "/bin/com.toptutoring.auto.deploy.plist").freeze

def shell_success?
  $?.exitstatus == 0
end

def rbenv_and_terminal?
  system("which rbenv") && system("which terminal-notifier")
end

def install(original, new, text)
  `cp #{original} #{new}`
  if shell_success?
    File.open(new, "w") do |file|
      file.puts text
    end
    STDOUT.puts "Created file #{new}"
  else
    STDOUT.puts "Error while creating file #{new}"
  end
end

def text_for_program
  program_text = File.read(PATH_TO_DEPLOY_PROGRAM)
  program_text.gsub!("INSTALL_TTUTORING_PATH", PATH_TO_TTUTORING)
  program_text.gsub!("INSTALL_TERMINAL_NOTIFIER_PATH", USER_DIRECTORY + "/.rbenv/shims/terminal-notifier")
end

def text_for_plist
  plist_text = File.read(PATH_TO_PLIST)
  plist_text.gsub!("INSTALL_RUBY_PATH", `which ruby`.chomp)
  plist_text.gsub!("INSTALL_SCRIPT_PATH", PATH_TO_LAUNCH_PROGRAM)
end

def load_program
  `launchctl load #{PATH_TO_LAUNCH_PLIST}`
  if shell_success?
    STDOUT.puts "Installed successfully"
  else
    STDOUT.puts "Error while loading launch agent. Please check to see if #{PATH_TO_LAUNCH_PLIST} has been created successfully. Load manually by using the command: launchctl load #{PATH_TO_LAUNCH_PLIST}"
  end
end

if File.exists?(PATH_TO_LAUNCH_PLIST)
  STDOUT.puts "Already installed"
elsif !rbenv_and_terminal?
  STDOUT.puts "This program requires rbenv and terminal-notifier. Please install before continuing."
else
  install PATH_TO_DEPLOY_PROGRAM, PATH_TO_LAUNCH_PROGRAM, text_for_program
  install PATH_TO_PLIST, PATH_TO_LAUNCH_PLIST, text_for_plist
  load_program
end
