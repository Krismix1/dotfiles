local M = {}

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local util = require("lspconfig/util")
local path = util.path
function M.get_python_path_local_venv(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  local match = vim.fn.glob(path.join(workspace, '.venv'))
  if match ~= '' then
    return path.join(match, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

function M.get_python_path_poetry_venv(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV)
  end

  local match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
  if match ~= '' then
    local venv = vim.fn.trim(vim.fn.system('poetry env info -p'))
    return venv
  end

  return nil
end

function M.get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  local venv = M.get_python_path_poetry_venv(workspace)
  if venv then
    return path.join(venv, 'bin', 'python')
  end

  -- Fallback to system Python.
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

M.exists = function(file)
  -- https://stackoverflow.com/a/40195356/4000764
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

return M
