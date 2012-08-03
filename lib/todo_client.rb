require "rest-client"

class TodoClient

  HOST = "http://todos.dev/"

  def run
    puts "Welcome to the Garden of Goals Command Line Interface!"
    command = ""
    while command != "quit"
      printf "Enter Command: "
      command = gets.chomp
      command_array = command.split


      case command_array[0]
        when "show"

          if command_array[1] == "lists"
            index_lists

          elsif command_array[1] == "list" && command_array[2]
            list_id = command_array[2]

            show_list(list_id)
          end


        when "add"

          if command_array[1] == "list"

            if command_array[3] == "task"

              list_id = command_array[2]
              text = command_array[4..-1].join(" ")
              create_task(list_id, text)

            else
              name = command_array[2..-1].join(" ")
              create_list(name)
            end

          end


        when "rename"

          if command_array[1] == "list"

            list_id = command_array[2]

            if command_array[3] == "task"

              task_id = command_array[4]

              text = command_array[5..-1].join(" ")
              rename_task(list_id, task_id, text)

            else
              name = command_array[3..-1].join(" ")
              rename_list(list_id, name)
            end

          end

        when "delete"

          if command_array[1] == "list"

            list_id = command_array[2]

            if command_array[3] == "task"

              task_id = command_array[4]

              delete_task(list_id, task_id)

            else
              delete_list(list_id)
            end

          end

        when "check"

          if command_array[1] == "list"

            list_id = command_array[2]

            if command_array[3] == "task"

              task_id = command_array[4]

              complete_task(list_id, task_id, true)

            end

          end

        when "uncheck"

          if command_array[1] == "list"

            list_id = command_array[2]

            if command_array[3] == "task"

              task_id = command_array[4]

              complete_task(list_id, task_id, false)

            end

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

    if method == :get
      response = RestClient.get(url, params)
    else

      if method == :put
        params << {"_method" => "put"}
      elsif method == :delete
        params << {"_method" => "delete"}
      end

      response = RestClient.post(url, params)
    end

    puts response
    
    response
  end

  # LIST

  # show lists
  def index_lists
    path = "lists"
    request(path)
  end

  # show list 1
  def show_list(list_id)
    path = "lists/#{list_id}"
    request(path)
  end

  # add list Things to bring to fun day out
  def create_list(name)
    path = "lists"
    params = { list: { name: name }}
    request(path, params, :post)
  end

  # rename list 1 Bring stuff
  def rename_list(list_id, name)
    path = "lists/#{list_id}"
    params = { list: { name: name }}
    request(path, params, :put )
  end

  # delete list 1
  def destroy_list(list_id)
    path = "lists/#{list_id}"
    params = {}
    request(path, params, :delete )
  end


  # TASK


  # add list 1 task Buy some milk
  def create_task(list_id, text)
    path = "lists/#{list_id}/tasks"
    params = {task: {text: text}}
    request(path, params, :post)
  end

  # rename list 1 task 1 Buy some apples
  def rename_task(list_id, task_id, text)
    path = "lists/#{list_id}/tasks/#{task_id}"
    params = {task: {text: text}}
    request(path, params, :put)
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
  end

  # delete list 1 task 1
  def destroy_task(list_id, task_id)
    path = "lists/#{list_id}/tasks/#{task_id}"
    params = {}
    request(path, params, :delete)
  end

end