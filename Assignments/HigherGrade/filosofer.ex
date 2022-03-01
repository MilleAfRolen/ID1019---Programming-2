defmodule Chopstick do

  #pid = spawn(fn() -> Filo.start() end)

  def start() do
    stick = spawn_link(fn() -> Chopstick.available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit ->
        :ok
    end
  end

  def gone() do
    receive do
      :return ->
        available()
      :quit ->
        :ok
    end
  end

  def request(stick) do
    IO.puts("jek")
    send(stick, self())
    IO.puts("kej")
    receive do
      :granted -> 
        :ok
    end
  end

  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    send(stick, :quit)
  end
end


defmodule Philosopher do

  def start(hunger, right, left, name, ctrl) do
    spawn_link(fn() -> dreaming(hunger, right, left, name, ctrl) end)
  end

  def dreaming(0, _, _, name, ctrl) do
    send(ctrl, :done)
  end


  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming")
    sleep(100)
    IO.puts("#{name} wakes up")
    chopsticks(hunger, right, left, name, ctrl)
  end

  def chopsticks(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is waiting for chopsticks")
    case Chopstick.request(left) do
     :ok -> 
      IO.puts("#{name} got left chopstick")
    end
    Chopstick.request(right)
    IO.puts("#{name} got right chopstick")
    eat(hunger, right, left, name, ctrl)
  end

  def eat(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is eating")
    sleep(100)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger-1, left, right, name, ctrl)
  end




  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end


end

defmodule Dinner do

  def start() do
    spawn(fn() -> init() end)
  end

  def init() do
    c1 = Chopstick.start()
    c2 = Chopstick.start()
    c3 = Chopstick.start()
    c4 = Chopstick.start()
    c5 = Chopstick.start()
    IO.puts("Pp")
    ctrl = self()
    Philosopher.start(5, c1, c2, "Arendt", ctrl)
    Philosopher.start(5, c2, c3, "Hypatia", ctrl)
    Philosopher.start(5, c3, c4, "Simone", ctrl)
    Philosopher.start(5, c4, c5, "Elisabeth", ctrl)
    Philosopher.start(5, c5, c1, "Ayn", ctrl)
    wait(5, [c1, c2, c3, c4, c5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  end
  def wait(n, chopsticks) do
    receive do
      :done ->
        wait(n-1, chopsticks)
      :abort ->
        Process.exit(self(), :kill)
    end
  end
end
