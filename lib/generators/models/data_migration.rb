# Extending this class makes a migration that calls a rake task, e.g.
#
# ```
# class RunDoSomething < DataMigration
#   UP_RAKE_TASK = 'data:migrate:do_something'
#   DOWN_RAKE_TASK = 'data:migrate:undo_something'
# end
#
# This allows data migrations that will:
# 1. Run only once on deploy
# 2. Allow us to rerun a data migration separately through a rake task
# 3. Clean up old rake tasks without breaking past migrations

class DataMigration < ActiveRecord::Migration[5.1]
  def up
    unless up_rake_task_defined?
      fail NameError, <<-ERROR.strip_heredoc
        #{self.class}::UP_RAKE_TASK is not defined (or not defined properly). It
        should be a string name of the rake task to be run, e.g.

            UP_RAKE_TASK = 'data:migrate:some-task-here'
      ERROR
    end

    rake_task = self.class::UP_RAKE_TASK
    if Rake::Task.task_defined?(rake_task)
      STDOUT.puts green("  Running rake task: #{rake_task}")
      Rake::Task[rake_task].invoke
    else
      Rails.logger.warn <<-EOS.strip_heredoc
        #{rake_task} is not a rake task: migration not run
      EOS
    end
  end

  def down
    return unless down_rake_task_defined?

    rake_task = self.class::DOWN_RAKE_TASK
    if Rake::Task.task_defined?(rake_task)
      puts green("  Running rake task: #{rake_task}")
      Rake::Task[rake_task].invoke
    else
      Rails.logger.warn <<-EOS.strip_heredoc
        #{rake_task} is not a rake task: migration not run
      EOS
    end
  end

  private

  def green(str)
    "\e[32m#{str}\e[0m"
  end

  def down_rake_task_defined?
    defined?(self.class::DOWN_RAKE_TASK) && self.class::DOWN_RAKE_TASK.present?
  end

  def up_rake_task_defined?
    defined?(self.class::UP_RAKE_TASK) && self.class::UP_RAKE_TASK.present?
  end
end
