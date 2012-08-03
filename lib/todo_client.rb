require "rest-client"
require "json"

class TodoClient

  HOST = "http://todos.dev/"

  def run
    puts "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
    puts "Welcome to the Garden of Goals Command Line Interface!"
    puts "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
    puts ""
    puts "To view lists, type 'show lists'"
    command = ""
    while command != "quit"
      puts ""
      printf "Enter Command: "
      command = gets.chomp
      command_array = command.split
      puts ""


      list_id = nil
      task_id = nil

      if command_array[1] == "list" && command_array[2].to_i.to_s == command_array[2]
        list_id = command_array[2].to_i
      end

      if list_id && command_array[3] == "task" && command_array[4].to_i.to_s == command_array[4]
        task_id = command_array[4].to_i
      end

      case command_array[0]
        when "show"

          # show list 1
          if list_id
            show_list(list_id)

          # show lists
          elsif command_array[1] == "lists"
            index_lists
            
          end


        when "add"

          # add list 1 task
          if list_id && command_array[3] == "task"

            text = command_array[4..-1].join(" ")
            create_task(list_id, text)

          # add list
          elsif command_array[1] == "list"

            name = command_array[2..-1].join(" ")
            create_list(name)

          end


        when "rename"

          # rename list 1 task 1
          if list_id && task_id
            
            text = command_array[5..-1].join(" ")
            rename_task(list_id, task_id, text)            

          # rename list 1
          elsif list_id
            name = command_array[3..-1].join(" ")
            rename_list(list_id, name)          

          end


        when "delete"

          # delete list 1 task 1
          if list_id && task_id
            delete_task(list_id, task_id)

          # delete list 1
          elsif list_id
            delete_list(list_id)

          end

        when "check"

          # check list 1 task 1
          if list_id && task_id

            complete_task(list_id, task_id, true)

          end


        when "uncheck"

          # uncheck list 1 task 1 
          if list_id && task_id

              complete_task(list_id, task_id, false)

          end

        when "quit"
          puts "Goodbye!"

        when "help"
          puts "Ask Rose politely and with a smile :)"
        else
          puts "Sorry, we don't know what you are typing about. Type 'help' for instructions."
      end
    end        
  end

  def request(path, params={}, method=:get)
    url = HOST + path + ".json"

    # "Send" method calls first argument as method on object, with other arguments as method arguments.
    response = RestClient.send(method, url, params)

    # if method == :get
    #   response = RestClient.get(url, params)
    # else

    # THESE GUYS DON'T WORK, NEED RestClient.put or RestClient.delete methods
    #   if method == :put
    #     params.merge({"_method" => "put"})
    #   elsif method == :delete
    #     params.merge({"_method" => "delete"})
    #   end

    #   response = RestClient.post(url, params)
    # end

    # puts response
    
    parse_request(response)
  end

  def parse_request(response)
    # OK Request, no content as response
    if response == ""
      true
    # JSON content
    else
      JSON.parse(response, symbolize_names: true)
    end
  end


  # LIST

  # show lists
  def index_lists
    path = "lists"
    response = request(path)
    parse_index_lists(response)
  end

  def parse_index_lists(lists)
    if lists.empty?
      puts "Sorry, there are no lists found. Type: 'add list [name of list]' to create a new one."
    else
      puts "These are all the lists:"
      puts_line
      lists.each do |list|
        puts_list(list)
      end
      puts_line
      puts "To view tasks in one list, type: 'show list [List ID]'"
      puts_line
    end
  end

  # show list 1
  def show_list(list_id)
    path = "lists/#{list_id}"
    response = request(path)
    parse_show_list(response)
  end

  def parse_show_list(list_and_task_array)
    list = list_and_task_array[0]
    tasks = list_and_task_array[1]
    puts_list(list)
    puts_line
    if tasks.empty?
      puts "This list is still empty. To add one, type: 'add list #{list[:id]} task [name of your task]'"
    else
      tasks.each do |task|
        puts_task(task)
      end
      puts_line
      puts "To make a task completed or incomplete, type 'check list #{list[:id]} task [Task ID]' or 'uncheck list #{list[:id]} task [Task ID]'"
    end    
    puts_line
   
  end

  # add list Things to bring to fun day out
  def create_list(name)
    path = "lists"
    params = { list: { name: name }}
    list = request(path, params, :post)
    list_id = list[:id]
    # output full list again
    show_list(list_id)
  end

  # rename list 1 Bring stuff
  def rename_list(list_id, name)
    path = "lists/#{list_id}"
    params = { list: { name: name }}
    request(path, params, :put )
 
    # output full list again
    show_list(list_id)
  end

  # delete list 1
  def destroy_list(list_id)
    path = "lists/#{list_id}"
    params = {}
    request(path, params, :delete )
 
    #return to list of lists
    index_lists
  end


  # TASK


  # add list 1 task Buy some milk
  def create_task(list_id, text)
    path = "lists/#{list_id}/tasks"
    params = {task: {text: text}}
    request(path, params, :post)

    # output full list again
    show_list(list_id)
  end

  # rename list 1 task 1 Buy some apples
  def rename_task(list_id, task_id, text)
    path = "lists/#{list_id}/tasks/#{task_id}"
    params = {task: {text: text}}
    request(path, params, :put)
    
    # output full list again
    show_list(list_id)
  end

  # check list 1 task 1
  # uncheck list 1 task 1
  def complete_task(list_id, task_id, is_completed)
    path = "lists/#{list_id}/tasks/#{task_id}"
    if is_completed
      completed = 1
    else
      completed = 0
    end
    params = {task: {is_completed: completed}}
    request(path, params, :put)

    # output full list again
    show_list(list_id)
  end

  # delete list 1 task 1
  def destroy_task(list_id, task_id)
    path = "lists/#{list_id}/tasks/#{task_id}"
    params = {}
    request(path, params, :delete)
  end


  # PRESENTATION METHODS

  def puts_line
    puts "- - - - - - - - - - - - - - - - - - - - -"
  end

  def puts_list(list)
    if list[:tasks_count].to_i == 1
      task_count = list[:tasks_count].to_s + " task"
    else
      task_count = list[:tasks_count].to_s + " tasks"
    end
    puts "List ID: #{list[:id]}. #{list[:name]}  (#{task_count})"
  end

  def puts_task(task)
    if task[:is_completed]
      puts "[x] Task ID: #{task[:id]}. #{task[:text]}"
    else
      puts "[ ] Task ID: #{task[:id]}. #{task[:text]}"
    end
  end

end