require 'etc'
def greet() 
  name = Etc.getlogin
  puts "\t\t\t\t\tWelcome to your todo_list #{name}"
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
  print "\n["
  rest_task.times do
    print "\e[32m=\e[0m"
    sleep(0.01)
  end
  precantage_num.times do
    print "#"
    sleep(0.01)
  end
  print "]"
  if rest_task == 100
    puts "\n,WOW YOU´RE ALL DONE"
  end

end

def add_task(task_name)
  file_check1 = File.open('total_tasks', 'r').read.split(" ")
  if file_check1.include? task_name
    puts "Sorry #{task_name} already exsists"
  else
    File.open('current_tasks.txt', 'a') do |file|
      file.write("#{task_name}\n")
    end
    File.open('total_tasks', 'a') do |file|
      file.write("#{task_name}\n")
    end
  end

end
def finish_task(task_name)
  file_contents = File.open('current_tasks.txt')
  task_list = file_contents.read.split("\n")
  file_contents.close
  if task_list.include? task_name
    task_list.delete(task_name)
    File.write('completed_tasks',"#{task_name}\n",mode: "a" ) 
    File.write("current_tasks.txt", "")
    task_list.each do | writee |
      File.write('current_tasks.txt',"#{writee}\n",mode: "a" ) 
    end
    puts"ok you just finished #{task_name} good job"
  else
    puts "This Task dosent exist would you like to add #{task_name} as a task\ny/n"
    yn = gets.chomp
    if yn == "y"
      add_task(task_name)
      task_list.delete(task_name)
      File.write('completed_tasks',"#{task_name}\n",mode: "a" ) 
      File.write("current_tasks.txt", "")
      task_list.each do | writee |
        File.write('current_tasks.txt',"#{writee}\n",mode: "a" ) 
      end
    end

  end
end
def reset()
  File.write("current_tasks.txt", "All_done\n")
  File.write("total_tasks", "All_done \n")
  File.write("completed_tasks", "")
end
def un_finish_task(task_name)
  file_contents = File.open('completed_tasks')
  task_list = file_contents.read.split("\n")
  file_contents.close
  if task_list.include? task_name
    task_list.delete(task_name)
    File.write('current_tasks.txt',"#{task_name}\n",mode: "a" ) 
    File.write("completed_tasks", "")
    task_list.each do | writee |
      File.write('completed_tasks',"#{writee}\n",mode: "a" ) 
    end
    puts"ok you just unfinished #{task_name} "
  else  
    puts "This task dose not exsist\nWould you like to add #{task_name} as a task \ny/n"
    yn = gets.chomp
    if yn == "y"
      add_task(task_name)
    end
  end

end
def delet_task_from_file(task_name,filename)
  file_contents = File.open("#{filename}")
  task_list = file_contents.read.split("\n")
  task_list.delete(task_name)
  File.write("#{filename}","",mode: "w" )
  task_list.each do |writee|
    File.write("#{filename}","#{writee}\n",mode: "a" ) 
  end
end
def delete_task(task_name)
  delet_task_from_file(task_name,'current_tasks.txt')
  delet_task_from_file(task_name,'completed_tasks')
  file_contents = File.open("total_tasks")
  task_list = file_contents.read.split("\n")
  task_list.delete(task_name)
  File.write("total_tasks","",mode: "w" )
  task_list.each do | writee |
    File.write("total_tasks","#{writee}\n",mode: "a" ) 
  end
end

def crud()
  puts"\n\t\t\t\t\t    what do you want to do?\n\n\nadd a task(add)\nfinish a task(fin)\nUn-finish task (unfin)\nReset (re)\nDelete task(del)\nExit (ex)"
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
    delete_task(filename)
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
