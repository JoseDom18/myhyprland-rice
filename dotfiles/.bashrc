#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Habilitar autocompletado de bash
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

# Configuración persistente para ssh-agent
SSH_ENV="$HOME/.ssh/agent_env"

function start_agent {
  # Inicia el agente y guarda las variables en el archivo
  ssh-agent -s | sed 's/^echo/#echo/' >"${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  source "${SSH_ENV}" >/dev/null

  # Agrega tus llaves automáticamente cuando se crea el nuevo agente
  ssh-add ~/.ssh/id_ed25519_personal ~/.ssh/id_ed25519_trabajo 2>/dev/null
}

# Comprueba si el archivo de entorno ya existe
if [ -f "${SSH_ENV}" ]; then
  source "${SSH_ENV}" >/dev/null
  # Verifica si el proceso con el PID guardado sigue activo
  if ! kill -0 "${SSH_AGENT_PID}" 2>/dev/null; then
    start_agent
  fi
else
  start_agent
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
