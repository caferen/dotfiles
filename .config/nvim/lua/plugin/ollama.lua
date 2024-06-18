local ollama = require('ollama')

ollama.setup {
	model = 'llama3',
	url = 'http://127.0.0.1:11434',
	serve = {
		on_start = false,
		command = 'ollama',
		args = { 'serve' },
		stop_command = 'pkill',
		stop_args = { '-SIGTERM', 'ollama' },
	},
	prompts = {
		Grammarly = {
			prompt =
				"Rewrite below paragraph. Correct grammar, punctuation, "
				.. "and vocabulary errors. Make it more readable, idiomatic, and concise. "
				.. "Reformat the result so that each line contains a maximum of 80 characters. "
				.. "Here's the input: \n\n $sel "
				.. "Respond EXACTLY in this format:\n```$ftype\n<your code>\n```",
			model = "llama3",
			action = "replace",
		}
	}
}

vim.keymap.set({ "n", "v" }, "<leader>o", ollama.prompt)
