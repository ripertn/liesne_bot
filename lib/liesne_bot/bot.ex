defmodule LiesneBot.Bot do
  @bot :liesne_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")
  command("ioui")
  command("adresse")
  command("shinkansen", description: "next train to Paris from Melun")
  command("zou")


  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    s = ~S"""
    next train Melun to Paris
      \shinkansen
    next train Fontainebleau to Paris
      \zou Fontainebleau Paris
    """
    answer(context, s)
  end

  def handle({:command, :ioui, _msg}, context) do
    answer(context, "rrrrou")
  end

  def handle({:command, :adresse, _msg}, context) do
    answer(context, "5 rue saint Liesne, 77000 Melun")
  end

  def handle({:command, :shinkansen, _msg}, context) do
    res = Prim.get_next_train()
    answer(context, res)
  end

  def handle({:command, :zou, msg}, context) do
    IO.inspect(msg)
    res = Prim.get_next_train(msg[:text])
    answer(context, res)
  end

  # LiesneBot.Bot.handle(
  #   {:command,
  #   "zou", 
  #   %{chat:
  #         %{first_name: "Crocmignon", id: 886129991, type: "private"},
  #         date: 1668369716,
  #         entities: [%{length: 4, offset: 0, type: "bot_command"}],
  #         from: %{first_name: "Crocmignon", id: 886129991, is_bot: false, language_code: "fr"},
  #         message_id: 94, text: "to to"}
  #     },
  #     %ExGram.Cnt{
  #                 answers: [],
  #                 bot_info: %ExGram.Model.User{
  #                                               added_to_attachment_menu: nil,
  #                                               can_join_groups: true,
  #                                               can_read_all_group_messages: false,
  #                                               first_name: "liesne",
  #                                               id: 5628609758,
  #                                               is_bot: true,
  #                                               is_premium: nil,
  #                                               language_code: nil,
  #                                               last_name: nil,
  #                                               supports_inline_queries: false,
  #                                               username: "liesne_bot"
  #                                               },
  #                 commands: [
  #                   [command: "start", name: :start, description: nil],
  #                   [command: "help", name: :help, description: "Print the bot's help"],
  #                   [command: "ioui", name: :ioui, description: nil],
  #                   [command: "adresse", name: :adresse, description: nil],
  #                   [command: "shinkansen", name: :shinkansen, description: "next train to Paris from Melun"]], extra: %{}, halted: false, message: nil, middleware_halted: false, middlewares: [], name: :liesne_bot, regex: [], responses: [], update: %ExGram.Model.Update{callback_query: nil, channel_post: nil, chat_join_request: nil, chat_member: nil, chosen_inline_result: nil, edited_channel_post: nil, edited_message: nil, inline_query: nil, message: %{chat: %{first_name: "Crocmignon", id: 886129991, type: "private"}, date: 1668369716, entities: [%{length: 4, offset: 0, type: "bot_command"}], from: %{first_name: "Crocmignon", id: 886129991, is_bot: false, language_code: "fr"}, message_id: 94, text: "/zou to to"}, my_chat_member: nil, poll: nil, poll_answer: nil, pre_checkout_query: nil, shipping_query: nil, update_id: 561133684}})


end
