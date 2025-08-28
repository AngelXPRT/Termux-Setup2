#!/data/data/com.termux/files/usr/bin/bash
# ================================
# Full Setup Termux (minimal pero completo)
# ================================

echo -e "\n[+] Actualizando paquetes..."
pkg update -y && pkg upgrade -y

echo -e "\n[+] Instalando paquetes esenciales..."
pkg install -y git curl wget unzip zip tar clang make cmake pkg-config \
               python openssl openssh tmux neovim micro \
               zsh fish fzf ripgrep fd bat eza lazygit \
               proot-distro translate-shell termux-api jq

# Configuración de almacenamiento
termux-setup-storage

echo -e "\n[+] Instalando pip y deep-translator..."
pip install --upgrade pip
pip install deep-translator

echo -e "\n[+] Configurando alias útiles..."
{
  echo "alias ls='eza --group-directories-first --icons=auto'"
  echo "alias cat='bat'"
  echo "alias grep='rg'"
  echo "alias find='fd'"
  echo "alias traduce='trans -b :es'"
  echo "alias python='python3'"
} >> ~/.bashrc

# ================================
# Instalación de Zsh + Plugins
# ================================
echo -e "\n[+] Instalando Oh My Zsh..."
rm -rf ~/.oh-my-zsh
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\n[+] Instalando plugins Zsh..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Edita ~/.zshrc para activar plugins
sed -i 's/^plugins=(.*/plugins=(git fzf z zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo -e "\n[+] Instalando Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

# ================================
# Configuración de proot-distro (Ubuntu)
# ================================
echo -e "\n[+] Instalando Ubuntu en proot-distro..."
proot-distro install ubuntu
proot-distro login ubuntu --shared-tmp --user root <<'EOF'
apt update && apt -y upgrade
apt -y install python3 python3-pip git build-essential sudo curl wget
EOF

# ================================
# Final
# ================================
echo -e "\n[✓] Instalación completa."
echo -e "👉 Usa 'zsh' para entrar a tu shell con temas y plugins."
echo -e "👉 Usa 'proot-distro login ubuntu' para entrar a tu Linux completo."
echo -e "👉 Usa 'traduce <texto>' para traducir al español."
echo -e "👉 Atajos: Ctrl-R (historial), Alt-. (último argumento), !! (último comando)."