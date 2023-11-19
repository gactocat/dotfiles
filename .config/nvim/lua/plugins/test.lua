return {
  { "nvim-neotest/neotest-jest" },
  { "nvim-neotest/neotest-go" },
  { "nvim-neotest/neotest-plenary" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        "neotest-jest",
        "neotest-go",
        "neotest-plenary",
      },
    },
  },
}
