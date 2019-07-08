
function async_git_branch
  sleep 2;
  echo (set_color white)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)
end

function prompt_arrow
  echo (set_color green)"❯"(set_color normal)
end

function prompt_dir
  echo (set_color blue)(prompt_pwd)(set_color normal)
end
