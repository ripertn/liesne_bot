defmodule LiesneBot.Bot do
  @bot :liesne_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true
  require Logger

  command("start")
  command("help", description: "Print the bot's help")
  command("train", description: "next trains at Melun station")


  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context,
    ~S"""
      Hi! you want timetable of next trains ? try for example:
        /train Fontainebleau
      or
        /train Melun Paris
      more details with:
        /help
    """)
  end

  def handle({:command, :help, _msg}, context) do
    s = ~S"""
    next trains stoping at Melun
      \train
    next train stoping at Fontainebleau and going to Paris
      \train Fontainebleau Paris
    """
    answer(context, s)
  end

  def handle({:command, :train, msg}, context) do
    Logger.info(IO.inspect(msg))
    txt = msg[:text] != "" && msg[:text] || "melun"
    res = Prim.get_trains(txt)
    answer(context, res)
  end

end
