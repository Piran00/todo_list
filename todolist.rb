require 'etc'
def greet() 
  name = Etc.getlogin
  puts "\t\t\t\t\t  Welcome to your todo_list #{name}"
  return name
end
def display_tasks()
   file_contents = File.open('current_tasks.txt')
   task_list = file_contents.read.split("\n")
   file_contents.close
   task_list.each  do |task|
    puts "#{task}[ ]"
   end
   file_contents = File.open('completed_tasks')
   task_list = file_contents.read.split("\n")
   file_contents.close
   task_list.each  do |task|
    puts "#{task}[✓]"
   end
end
def count_tasks(file)
  file_contents = File.open("#{file}")
  pending_tasks = file_contents.read.split("\n").count
  file_contents.close
  return pending_tasks
end
def progress_bar()
  pending_tasks = count_tasks('current_tasks.txt') * 100
  total_tasks = count_tasks('total_tasks') 
  precantage_num = pending_tasks / total_tasks
  rest_task = 100 - precantage_num
  puts "\t\t\t\t\t    Youre \e[32m#{rest_task}%\e[0m done"
  puts "["+ "\e[32m-\e[0m" * rest_task + "#" * precantage_num + "]"
end
def add_task(task_name)
  File.open('current_tasks.txt', 'a') do |file|
    file.write("#{task_name}\n")
  end
  File.open('total_tasks', 'a') do |file|
    file.write("\n#{task_name}")
  end
end
def finish_task(task_name)
  file_contents = File.open('current_tasks.txt')
  task_list = file_contents.read.split("\n")
  file_contents.close
  puts task_list
  if task_list.include? task_name
    task_list.delete(task_name)
    File.write('completed_tasks',"#{task_name}\n",mode: "a" ) 
    File.write("current_tasks.txt", "")
    task_list.each do | writee |
      File.write('current_tasks.txt',"#{writee}\n",mode: "a" ) 
    end
    puts"ok you just finished #{task_name} good job"
  else
    puts "this Task dosent exist currently\n do you want to add it y/n"
    yn = gets.chomp
    if yn == "y"
      add_task(task_name)
    end

  end
end
def reset()
  File.write("current_tasks.txt", "nothing\n")
  File.write("total_tasks", "nothing")
  File.write("completed_tasks", "")
end
def un_finish_task(task_name)
  file_contents = File.open('completed_tasks')
  task_list = file_contents.read.split("\n")
  file_contents.close
  puts task_list
  if task_list.include? task_name
    task_list.delete(task_name)
    File.write('current_tasks.txt',"#{task_name}\n",mode: "a" ) 
    File.write("completed_tasks", "")
    task_list.each do | writee |
      File.write('completed_tasks',"#{writee}\n",mode: "a" ) 
    end
    puts"ok you just unfinished #{task_name} "
  end

end

def crud()
  puts"\t\t\t\t\t    what do you want to do?\nadd a task(add)\nfinish a task(fin)\nUn-finish task (unfin)\nReset (re)\nDelete task(del)\nExit (ex)"
  input = gets.chomp
  action , filename = input.split(" ")
  case action
  when "add"
    add_task(filename)
  when "fin"
    finish_task(filename)
  when "unfin"
    un_finish_task(filename)
  when "re"
    reset
  when "del"
  when "ex"
    puts"see you next time"
    puts "\e[H\e[2J"
    exit!
  end
  puts "\e[H\e[2J"
end
def main()
  while true
  greet
  display_tasks
  progress_bar
  crud
  end
end
main