return {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Go to left pane/window" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Go to lower pane/window" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Go to upper pane/window" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right pane/window" },
    },
  },
}
