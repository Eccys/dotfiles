-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/luasnip.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/luasnip.lua

-- This allows me to create my custom snippets
-- All you need to do, if using the lazyvim.org distro, is to enable the
-- coding.luasnip LazyExtra and then add this file

-- If you're a dotfiles scavenger, definitely watch this video (you're welcome)
-- https://youtu.be/FmHhonPjvvA?si=8NrcRWu4GGdmTzee

return {
	"L3MON4D3/LuaSnip",
	enabled = true,
	opts = function(_, opts)
		local ls = require("luasnip")

		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node

		local function clipboard()
			return vim.fn.getreg("+")
		end

		-- Base function to process YouTube snippets with custom formatting
		local function process_youtube_snippets(file_path, format_func)
			local snippets = {}
			local file = io.open(file_path, "r")
			if not file then
				vim.notify("Could not open snippets file: " .. file_path, vim.log.levels.ERROR)
				return snippets
			end

			local lines = {}
			for line in file:lines() do
				if line == "" then
					if #lines == 2 then
						local title, url = lines[1], lines[2]
						local formatted_content = format_func(title, url)
						table.insert(snippets, formatted_content)
					end
					lines = {}
				else
					table.insert(lines, line)
				end
			end

			-- Handle the last snippet if file doesn't end with blank line
			if #lines == 2 then
				local title, url = lines[1], lines[2]
				local formatted_content = format_func(title, url)
				table.insert(snippets, formatted_content)
			end

			file:close()
			return snippets
		end

		-- Format functions for different types of YouTube snippets
		local format_functions = {
			plain = function(title, url)
				return s({ trig = "yt - " .. title }, { t(title), t({ "", url }) })
			end,

			markdown = function(title, url)
				local safe_title = string.gsub(title, "|", "-")
				local markdown_link = string.format("[%s](%s)", safe_title, url)
				return s({ trig = "ytmd - " .. title }, { t(markdown_link) })
			end,

			markdown_external = function(title, url)
				local safe_title = string.gsub(title, "|", "-")
				local markdown_link = string.format('[%s](%s){:target="_blank"}', safe_title, url)
				return s({ trig = "ytex - " .. title }, { t(markdown_link) })
			end,

			-- Extract video ID from URL (everything after the last /)
			embed = function(title, url)
				local video_id = url:match(".*/(.*)")
				local embed_code = string.format("{%% include embed/youtube.html id='%s' %%}", video_id)
				return s({ trig = "ytem - " .. title }, { t(embed_code) })
			end,
		}

		-- Path to the text file containing video snippets
		local snippets_file = vim.fn.expand("~/github/obsidian_main/300-youtube/youtube-video-list.txt")

		-- Generate all types of snippets using the base function
		local video_snippets = process_youtube_snippets(snippets_file, format_functions.plain)
		local video_md_snippets = process_youtube_snippets(snippets_file, format_functions.markdown)
		local video_md_snippets_ext = process_youtube_snippets(snippets_file, format_functions.markdown_external)
		local video_snippets_embed = process_youtube_snippets(snippets_file, format_functions.embed)

		-- Add all types of snippets to the "all" filetype
		ls.add_snippets("all", video_snippets)
		ls.add_snippets("all", video_md_snippets)
		ls.add_snippets("all", video_md_snippets_ext)
		ls.add_snippets("all", video_snippets_embed)

		-- Custom snippets
		-- the "all" after ls.add_snippets("all" is the filetype, you can know a
		-- file filetype with :set ft
		-- Custom snippets

		-- #####################################################################
		--                            Markdown
		-- #####################################################################

		-- Helper function to create code block snippets
		local function create_code_block_snippet(lang)
			return s({
				trig = lang,
				name = "Codeblock",
				desc = lang .. " codeblock",
			}, {
				t({ "```" .. lang, "" }),
				i(1),
				t({ "", "```" }),
			})
		end

		-- Define languages for code blocks
		local languages = {
			"txt",
			"lua",
			"sql",
			"go",
			"regex",
			"bash",
			"markdown",
			"markdown_inline",
			"yaml",
			"json",
			"jsonc",
			"cpp",
			"css",
			"c",
			"csv",
			"java",
			"javascript",
			"python",
			"dockerfile",
			"html",
			"css",
			"templ",
			"php",
		}

		-- Generate snippets for all languages
		local snippets = {}

		for _, lang in ipairs(languages) do
			table.insert(snippets, create_code_block_snippet(lang))
		end

		table.insert(
			snippets,
			s({
				trig = "chirpy",
				name = "Disable markdownlint and prettier for chirpy",
				desc = "Disable markdownlint and prettier for chirpy",
			}, {
				t({
					" ",
					"<!-- markdownlint-disable -->",
					"<!-- prettier-ignore-start -->",
					" ",
					"<!-- tip=green, info=blue, warning=yellow, danger=red -->",
					" ",
					"> ",
				}),
				i(1),
				t({
					"",
					"{: .prompt-",
				}),
				-- In case you want to add a default value "tip" here, but I'm having
				-- issues with autosave
				-- i(2, "tip"),
				i(2),
				t({
					" }",
					" ",
					"<!-- prettier-ignore-end -->",
					"<!-- markdownlint-restore -->",
				}),
			})
		)

		table.insert(
			snippets,
			s({
				trig = "markdownlint",
				name = "Add markdownlint disable and restore headings",
				desc = "Add markdownlint disable and restore headings",
			}, {
				t({
					" ",
					"<!-- markdownlint-disable -->",
					" ",
					"> ",
				}),
				i(1),
				t({
					" ",
					" ",
					"<!-- markdownlint-restore -->",
				}),
			})
		)

		table.insert(
			snippets,
			s({
				trig = "prettierignore",
				name = "Add prettier ignore start and end headings",
				desc = "Add prettier ignore start and end headings",
			}, {
				t({
					" ",
					"<!-- prettier-ignore-start -->",
					" ",
					"> ",
				}),
				i(1),
				t({
					" ",
					" ",
					"<!-- prettier-ignore-end -->",
				}),
			})
		)

		table.insert(
			snippets,
			s({
				trig = "linkt",
				name = 'Add this -> [](){:target="_blank"}',
				desc = 'Add this -> [](){:target="_blank"}',
			}, {
				t("["),
				i(1),
				t("]("),
				i(2),
				t('){:target="_blank"}'),
			})
		)

		table.insert(
			snippets,
			s({
				trig = "todo",
				name = "Add TODO: item",
				desc = "Add TODO: item",
			}, {
				t("<!-- TODO: "),
				i(1),
				t(" -->"),
			})
		)

		-- Paste clipboard contents in link section, move cursor to ()
		table.insert(
			snippets,
			s({
				trig = "linkc",
				name = "Paste clipboard as .md link",
				desc = "Paste clipboard as .md link",
			}, {
				t("["),
				i(1),
				t("]("),
				f(clipboard, {}),
				t(")"),
			})
		)

		-- Paste clipboard contents in link section, move cursor to ()
		table.insert(
			snippets,
			s({
				trig = "linkcex",
				name = "Paste clipboard as EXT .md link",
				desc = "Paste clipboard as EXT .md link",
			}, {
				t("["),
				i(1),
				t("]("),
				f(clipboard, {}),
				t('){:target="_blank"}'),
			})
		)

		-- Inserting "my dotfiles" link
		table.insert(
			snippets,
			s({
				trig = "dotfiles",
				name = "Adds -> [my dotfiles](https://github.com/ecys/dotfiles)",
				desc = "Add link to https://github.com/ecys/dotfiles",
			}, {
				t("[my dotfiles](https://github.com/ecys/dotfiles)"),
			})
		)

		table.insert(
			snippets,
			s({
				trig = "ecys",
				name = "My website",
				desc = "https://ecys.xyz",
			}, {
				t({
					"Members only discord -> https://www.youtube.com/channel/UCrSIvbFncPSlK6AdwE2QboA/join",
					"☕ Support me -> https://ko-fi.com/linkarzu",
					"☑ My Twitter -> https://x.com/link_arzu",
					"[Ecys](https:/ecys.xyz)",
				}),
			})
		)
		-- Basic JavaScript script template
		table.insert(
			snippets,
			s({
				trig = "jsex",
				name = "Basic JavaScript script example",
				desc = "Simple JavaScript script template",
			}, {
				t({
					"```javascript",
					"#!/usr/bin/env node",
					"",
					"console.log('Hello, JavaScript!');",
					"```",
					"",
				}),
			})
		)

		-- Basic C script template
		table.insert(
			snippets,
			s({
				trig = "cex",
				name = "Basic C script example",
				desc = "Simple C script template",
			}, {
				t({
					"```c",
					"#include <stdio.h>",
					"",
					"int main() {",
					'    printf("Hello, C!\\n");',
					"    return 0;",
					"}",
					"```",
					"",
				}),
			})
		)

		-- Basic C++ script template
		table.insert(
			snippets,
			s({
				trig = "cppex",
				name = "Basic C++ script example",
				desc = "Simple C++ script template",
			}, {
				t({
					"```cpp",
					"#include <iostream>",
					"",
					"int main() {",
					'    std::cout << "Hello, C++!" << std::endl;',
					"    return 0;",
					"}",
					"```",
					"",
				}),
			})
		)

		-- Basic C# script template
		table.insert(
			snippets,
			s({
				trig = "cshex",
				name = "Basic C# script example",
				desc = "Simple C# script template",
			}, {
				t({
					"```csharp",
					"using System;",
					"",
					"class Program {",
					"    static void Main() {",
					'        Console.WriteLine("Hello, C#!");',
					"    }",
					"}",
					"```",
					"",
				}),
			})
		)

		-- Basic bash script template
		table.insert(
			snippets,
			s({
				trig = "bashex",
				name = "Basic bash script example",
				desc = "Simple bash script template",
			}, {
				t({
					"```bash",
					"#!/bin/bash",
					"",
					"echo 'helix'",
					"echo 'deeznuts'",
					"```",
					"",
				}),
			})
		)

		-- Basic Python script template
		table.insert(
			snippets,
			s({
				trig = "pythonex",
				name = "Basic Python script example",
				desc = "Simple Python script template",
			}, {
				t({
					"```python",
					"#!/usr/bin/env python3",
					"",
					"def main():",
					"    print('helix dizpython')",
					"",
					"if __name__ == '__main__':",
					"    main()",
					"```",
					"",
				}),
			})
		)
		-- Basic Java script template
		table.insert(
			snippets,
			s({
				trig = "javaex",
				name = "Basic Java script example",
				desc = "Simple Java script template",
			}, {
				t({
					"```java",
					"public class Main {",
					"    public static void main(String[] args) {",
					'        System.out.println("Hello, Java!");',
					"    }",
					"}",
					"```",
					"",
				}),
			})
		)

		ls.add_snippets("markdown", snippets)

		-- #####################################################################
		--                         all the filetypes
		-- #####################################################################
		ls.add_snippets("all", {
			s({
				trig = "workflow",
				name = "Add this -> lamw25wmal",
				desc = "Add this -> lamw25wmal",
			}, {
				t("lamw25wmal"),
			}),

			s({
				trig = "lam",
				name = "Add this -> lamw25wmal",
				desc = "Add this -> lamw25wmal",
			}, {
				t("lamw25wmal"),
			}),

			s({
				trig = "mw25",
				name = "Add this -> lamw25wmal",
				desc = "Add this -> lamw25wmal",
			}, {
				t("lamw25wmal"),
			}),
		})

		return opts
	end,
}
