#!/bin/bash
# ============================================================
# Instalador do Assistente Pessoal Remoto (Claude Code + Telegram)
# Inspirado em OpenClaw + Vellum Assistant
#
# Uso: bash instalar-assistente.sh
# Compatível com: macOS (Apple Silicon e Intel)
# ============================================================

set -e

VERMELHO='\033[0;31m'
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
SEM_COR='\033[0m'

info()    { echo -e "${AZUL}[INFO]${SEM_COR} $1"; }
sucesso() { echo -e "${VERDE}[OK]${SEM_COR} $1"; }
aviso()   { echo -e "${AMARELO}[AVISO]${SEM_COR} $1"; }
erro()    { echo -e "${VERMELHO}[ERRO]${SEM_COR} $1"; exit 1; }

echo ""
echo "============================================================"
echo "  Assistente Pessoal Remoto — Instalador"
echo "  Claude Code + Telegram | Inspirado em OpenClaw + Vellum"
echo "============================================================"
echo ""

# ── Verificar macOS ──────────────────────────────────────────
if [[ "$OSTYPE" != "darwin"* ]]; then
  erro "Este instalador é apenas para macOS."
fi

# ── Coletar configurações ────────────────────────────────────
echo ""
echo "Antes de instalar, preciso de algumas informações suas."
echo "Vou te guiar passo a passo em cada uma. Não precisa ter"
echo "pressa — leia com calma e siga as instruções."
echo ""
read -p "Primeiro: qual é o seu nome? (só o primeiro nome): " NOME_USUARIO
echo ""

# ════════════════════════════════════════════════════════════════
# PASSO 1 — BOT DO TELEGRAM
# ════════════════════════════════════════════════════════════════
echo "════════════════════════════════════════════════════════════"
echo "  PASSO 1 DE 3 — Criar o bot no Telegram"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "O assistente precisa de um \"bot\" no Telegram para conseguir"
echo "receber e enviar mensagens pra você."
echo ""
echo "  Pense no bot como um número de telefone dedicado para o"
echo "  assistente. O Telegram tem um sistema chamado BotFather"
echo "  que cria esses bots gratuitamente."
echo ""
echo "Você já tem um bot criado no Telegram?"
echo ""
echo "  1) NÃO — quero criar um bot agora (mais comum)"
echo "  2) SIM — já tenho um bot e quero usar ele"
echo ""
read -p "Digite 1 ou 2: " OPCAO_BOT

if [ "$OPCAO_BOT" = "1" ]; then

  echo ""
  echo "────────────────────────────────────────────────────────────"
  echo "  Criando um bot novo — siga estes passos no Telegram:"
  echo "────────────────────────────────────────────────────────────"
  echo ""
  echo "  ATENÇÃO: faça esses passos agora, com o Telegram aberto"
  echo "  ao lado. Depois volte aqui para continuar."
  echo ""
  echo "  1. Abra o Telegram no celular ou computador"
  echo ""
  echo "  2. Na barra de pesquisa, digite: BotFather"
  echo "     Vai aparecer um contato com esse nome e um símbolo"
  echo "     de verificação azul (é o oficial do Telegram)"
  echo ""
  echo "  3. Clique nele e depois clique no botão INICIAR"
  echo "     (ou envie a mensagem: /start)"
  echo ""
  echo "  4. Ele vai mostrar uma lista de comandos. Envie:"
  echo "     /newbot"
  echo ""
  echo "  5. O BotFather vai perguntar: \"Alright, a new bot.\""
  echo "     \"How are you going to call it? Please choose a name"
  echo "     for your bot.\""
  echo ""
  echo "     Isso é o NOME de exibição do seu bot — o nome que"
  echo "     vai aparecer nas conversas. Pode ser qualquer coisa,"
  echo "     com espaços e acentos. Exemplos:"
  echo "       Meu Assistente"
  echo "       Assistente do João"
  echo "       Claude Pessoal"
  echo ""
  echo "     Digite o nome que quiser e envie."
  echo ""
  echo "  6. Agora ele vai pedir o USERNAME do bot."
  echo "     Isso é como um @ do Instagram — único no mundo,"
  echo "     sem espaços, sem acentos, e OBRIGATORIAMENTE"
  echo "     termina com a palavra 'bot'."
  echo ""
  echo "     Exemplos válidos:"
  echo "       meu_assistente_bot"
  echo "       assistente_joao_bot"
  echo "       claude_pessoal_bot"
  echo ""
  echo "     Se aparecer \"Sorry, this username is already taken\","
  echo "     é porque já existe. Tente outro nome."
  echo ""
  echo "  7. Quando der certo, o BotFather vai responder com uma"
  echo "     mensagem longa. No meio dela vai ter um TOKEN assim:"
  echo ""
  echo "     123456789:AAHxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  echo ""
  echo "     O token começa com números, tem dois pontos no meio,"
  echo "     e depois uma sequência longa de letras e números."
  echo "     Ele é a SENHA do seu bot — não compartilhe com"
  echo "     ninguém além deste instalador."
  echo ""
  echo "  8. Copie esse token inteiro (do primeiro número até"
  echo "     a última letra) e volte aqui."
  echo ""
  echo "────────────────────────────────────────────────────────────"
  echo ""
  read -p "  Cole o token aqui e aperte Enter: " BOT_TOKEN

else

  echo ""
  echo "────────────────────────────────────────────────────────────"
  echo "  Usando um bot existente — como encontrar o token:"
  echo "────────────────────────────────────────────────────────────"
  echo ""
  echo "  O token é a senha do seu bot. Veja como recuperá-lo:"
  echo ""
  echo "  1. Abra o Telegram e pesquise por: BotFather"
  echo "     (o contato com símbolo de verificação azul)"
  echo ""
  echo "  2. Envie o comando: /mybots"
  echo ""
  echo "  3. Vai aparecer uma lista com seus bots. Clique no"
  echo "     bot que você quer usar."
  echo ""
  echo "  4. Vai abrir um menu. Clique em: API Token"
  echo ""
  echo "  5. O BotFather vai mostrar o token. Copie ele inteiro."
  echo ""
  echo "  ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
  echo "  IMPORTANTE — se seu bot estava conectado a outro"
  echo "  programa antes (como n8n, Make, Heroku, ou qualquer"
  echo "  serviço online), não se preocupe: o instalador vai"
  echo "  desconectar automaticamente para que o assistente"
  echo "  passe a funcionar no seu lugar."
  echo "  ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"
  echo ""
  read -p "  Cole o token aqui e aperte Enter: " BOT_TOKEN

fi

# Validar formato do token
echo ""
if ! echo "$BOT_TOKEN" | grep -qE '^[0-9]{8,10}:[A-Za-z0-9_-]{35,}$'; then
  echo "  ⚠️  Atenção: o token parece estar incompleto ou incorreto."
  echo ""
  echo "  Um token válido tem este formato:"
  echo "  123456789:AAHxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  echo "  (números, dois pontos, letras e números — longo)"
  echo ""
  echo "  Dica: clique sobre o token no Telegram, segure até"
  echo "  selecionar tudo, depois copie e cole aqui."
  echo ""
  read -p "  Quer tentar colar de novo? (s = sim, n = continuar mesmo assim): " TENTAR_NOVAMENTE
  if [ "$TENTAR_NOVAMENTE" = "s" ]; then
    read -p "  Cole o token novamente: " BOT_TOKEN
  fi
fi

# ════════════════════════════════════════════════════════════════
# PASSO 2 — ID DO TELEGRAM
# ════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  PASSO 2 DE 3 — Seu ID numérico do Telegram"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "O assistente precisa saber com quem ele pode conversar."
echo "Para isso, usamos seu ID numérico do Telegram — um número"
echo "único que identifica sua conta (diferente do seu @username)."
echo ""
echo "  Não sabe qual é o seu ID? Siga estes passos:"
echo ""
echo "  1. No Telegram, pesquise por: userinfobot"
echo "     (vai aparecer um bot com esse nome)"
echo ""
echo "  2. Clique em INICIAR ou envie qualquer mensagem"
echo ""
echo "  3. Ele vai responder imediatamente com seus dados."
echo "     Procure a linha que diz \"Id:\" — o número do lado"
echo "     é o seu ID. Exemplo:"
echo "       Id: 8441066636"
echo ""
echo "  4. Copie só o número (sem a palavra \"Id:\")"
echo ""
read -p "  Cole seu ID numérico aqui: " TELEGRAM_CHAT_ID

# Validar que parece um número
if ! echo "$TELEGRAM_CHAT_ID" | grep -qE '^[0-9]{6,15}$'; then
  echo ""
  echo "  ⚠️  Isso não parece um ID numérico válido."
  echo "  O ID é só números, sem letras ou símbolos."
  echo "  Exemplo: 8441066636"
  echo ""
  read -p "  Quer tentar de novo? (s/n): " TENTAR_ID
  [ "$TENTAR_ID" = "s" ] && read -p "  Cole seu ID novamente: " TELEGRAM_CHAT_ID
fi

# ════════════════════════════════════════════════════════════════
# PASSO 3 — CHAVE DA ANTHROPIC
# ════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  PASSO 3 DE 3 — Chave da API da Anthropic (Claude)"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "O assistente é movido pelo Claude, a IA da Anthropic."
echo "Para funcionar, ele precisa de uma chave de acesso — pense"
echo "nela como um login que autoriza o uso do Claude."
echo ""
echo "  Se você ainda não tem uma chave:"
echo "  1. Acesse: console.anthropic.com"
echo "  2. Crie uma conta (ou faça login)"
echo "  3. Vá em: API Keys → Create Key"
echo "  4. Copie a chave gerada (começa com sk-ant-...)"
echo ""
echo "  Se você já tem uma chave, é só colá-la abaixo."
echo ""
echo "  IMPORTANTE: a chave não vai aparecer na tela enquanto"
echo "  você digita — isso é normal, é uma medida de segurança."
echo ""
read -sp "  Cole sua chave da Anthropic aqui: " ANTHROPIC_API_KEY
echo ""

if [ -z "$ANTHROPIC_API_KEY" ]; then
  erro "A chave da Anthropic não pode estar vazia. Execute o instalador novamente."
fi

# ════════════════════════════════════════════════════════════════
# CONFIGURAÇÃO OPCIONAL — HEARTBEAT
# ════════════════════════════════════════════════════════════════
echo ""
echo "────────────────────────────────────────────────────────────"
echo "  Configuração opcional: frequência de verificação"
echo "────────────────────────────────────────────────────────────"
echo ""
echo "O assistente verifica sua lista de tarefas pendentes"
echo "periodicamente — isso se chama \"heartbeat\"."
echo ""
echo "  A cada quantos minutos você quer que ele verifique?"
echo "  (Recomendado: 30 minutos. Aperte Enter para usar 30.)"
echo ""
read -p "  Minutos entre cada verificação [30]: " HEARTBEAT_INTERVALO
HEARTBEAT_INTERVALO=${HEARTBEAT_INTERVALO:-30}
HEARTBEAT_SEGUNDOS=$((HEARTBEAT_INTERVALO * 60))

echo ""
echo "────────────────────────────────────────────────────────────"
echo "  Tudo certo! Iniciando instalação..."
echo "  Isso pode levar alguns minutos — não feche o terminal."
echo "────────────────────────────────────────────────────────────"
echo ""
info "Iniciando instalação..."

# ── Homebrew ─────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Instalando Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Adicionar brew ao PATH para Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi
sucesso "Homebrew disponível"

# ── ffmpeg ────────────────────────────────────────────────────
if ! command -v ffmpeg &>/dev/null; then
  info "Instalando ffmpeg (necessário para converter áudio)..."
  brew install ffmpeg
fi
sucesso "ffmpeg disponível"

# ── Piper TTS (voz do assistente) ────────────────────────────
if ! command -v piper &>/dev/null; then
  info "Instalando Piper TTS..."
  brew install piper-tts
fi
sucesso "Piper TTS disponível"

# Baixar voz faber (PT-BR)
VOICES_DIR="$HOME/piper-voices"
mkdir -p "$VOICES_DIR"
FABER_MODEL="$VOICES_DIR/pt_BR-faber-medium.onnx"
FABER_CONFIG="$VOICES_DIR/pt_BR-faber-medium.onnx.json"

if [ ! -f "$FABER_MODEL" ]; then
  info "Baixando voz faber PT-BR (~65MB)..."
  curl -L -o "$FABER_MODEL" \
    "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx"
  curl -L -o "$FABER_CONFIG" \
    "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json"
  sucesso "Voz faber baixada"
else
  sucesso "Voz faber já disponível"
fi

# ── Whisper (transcrição de áudio — gratuito, local) ─────────
if ! python3 -c "import whisper" 2>/dev/null; then
  info "Instalando Whisper (transcrição de voz, gratuito)..."
  pip3 install openai-whisper
fi
sucesso "Whisper disponível"

# Pré-baixar modelo small do Whisper (~244MB, evita demora na primeira transcrição)
if [ ! -f "$HOME/.cache/whisper/small.pt" ]; then
  info "Baixando modelo Whisper 'small' (~244MB)..."
  python3 -c "import whisper; whisper.load_model('small')" 2>/dev/null
  sucesso "Modelo Whisper small baixado"
else
  sucesso "Modelo Whisper small já disponível"
fi

# ── Bun ──────────────────────────────────────────────────────
if ! command -v bun &>/dev/null && [ ! -f "$HOME/.bun/bin/bun" ]; then
  info "Instalando bun..."
  curl -fsSL https://bun.sh/install | bash
fi
export PATH="$HOME/.bun/bin:$PATH"
sucesso "bun disponível ($(bun --version))"

# ── Claude Code CLI ──────────────────────────────────────────
CLAUDE_BIN=""
if command -v claude &>/dev/null; then
  CLAUDE_BIN=$(command -v claude)
elif [ -f "$HOME/.local/bin/claude" ]; then
  CLAUDE_BIN="$HOME/.local/bin/claude"
fi

if [ -z "$CLAUDE_BIN" ]; then
  info "Claude Code não encontrado."
  echo ""
  echo "Instale o Claude Code antes de continuar:"
  echo "  → Baixe em: https://claude.ai/download"
  echo "  → Ou via npm: npm install -g @anthropic-ai/claude-code"
  echo ""
  read -p "Claude Code já instalado? Digite o caminho do binário (ou Enter para tentar npm): " CLAUDE_PATH_CUSTOM
  if [ -n "$CLAUDE_PATH_CUSTOM" ] && [ -f "$CLAUDE_PATH_CUSTOM" ]; then
    CLAUDE_BIN="$CLAUDE_PATH_CUSTOM"
  else
    info "Tentando instalar via npm..."
    npm install -g @anthropic-ai/claude-code
    CLAUDE_BIN=$(command -v claude)
  fi
fi
sucesso "Claude Code disponível em $CLAUDE_BIN"

# ── Configurar ANTHROPIC_API_KEY ─────────────────────────────
PROFILE_FILE="$HOME/.zshrc"
[ -f "$HOME/.bash_profile" ] && PROFILE_FILE="$HOME/.bash_profile"

if ! grep -q "ANTHROPIC_API_KEY" "$PROFILE_FILE" 2>/dev/null; then
  echo "export ANTHROPIC_API_KEY=\"$ANTHROPIC_API_KEY\"" >> "$PROFILE_FILE"
  export ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY"
  sucesso "ANTHROPIC_API_KEY configurada em $PROFILE_FILE"
else
  aviso "ANTHROPIC_API_KEY já existe em $PROFILE_FILE — não sobrescrevendo"
fi

# ── Estrutura de diretórios ──────────────────────────────────
info "Criando estrutura de diretórios..."
mkdir -p "$HOME/.claude/workspace/diario"
mkdir -p "$HOME/.claude/channels/telegram"
sucesso "Diretórios criados"

# ── Configurar bot Telegram ──────────────────────────────────
info "Configurando canal Telegram..."

# .env com o token
chmod 700 "$HOME/.claude/channels/telegram"
echo "TELEGRAM_BOT_TOKEN=$BOT_TOKEN" > "$HOME/.claude/channels/telegram/.env"
chmod 600 "$HOME/.claude/channels/telegram/.env"

# access.json com allowlist
cat > "$HOME/.claude/channels/telegram/access.json" << ACCESSJSON
{
  "dmPolicy": "allowlist",
  "allowFrom": [
    "$TELEGRAM_CHAT_ID"
  ],
  "groups": {},
  "pending": {}
}
ACCESSJSON
chmod 600 "$HOME/.claude/channels/telegram/access.json"
mkdir -p "$HOME/.claude/channels/telegram/approved"
sucesso "Canal Telegram configurado"

# ── Limpar webhook (evita conflito com serviços anteriores) ───
info "Verificando configuração do bot no Telegram..."
WEBHOOK_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getWebhookInfo" 2>/dev/null)
WEBHOOK_URL=$(echo "$WEBHOOK_INFO" | python3 -c "
import sys, json
try:
  d = json.load(sys.stdin)
  print(d.get('result', {}).get('url', ''))
except: print('')
" 2>/dev/null)

if [ -n "$WEBHOOK_URL" ]; then
  aviso "Bot estava conectado a outro serviço via webhook: $WEBHOOK_URL"
  info "Removendo webhook para usar com o assistente (long-polling)..."
  curl -s "https://api.telegram.org/bot${BOT_TOKEN}/deleteWebhook" >/dev/null 2>&1
  sucesso "Webhook removido — bot pronto para usar com o assistente"
else
  sucesso "Bot sem webhook ativo — nenhum conflito detectado"
fi

# Validar que o token funciona de fato
BOT_INFO=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getMe" 2>/dev/null)
BOT_USERNAME=$(echo "$BOT_INFO" | python3 -c "
import sys, json
try:
  d = json.load(sys.stdin)
  if d.get('ok'):
    print('@' + d['result']['username'])
  else:
    print('ERRO: ' + d.get('description', 'token inválido'))
except: print('ERRO: não foi possível verificar')
" 2>/dev/null)

if echo "$BOT_USERNAME" | grep -q "^@"; then
  sucesso "Bot verificado: $BOT_USERNAME"
else
  erro "Token inválido ou sem conexão: $BOT_USERNAME"
fi

# ── Instalar plugin Telegram ─────────────────────────────────
info "Instalando plugin Telegram do Claude Code..."

# Garantir que bun está no PATH antes de instalar o plugin
export PATH="$HOME/.bun/bin:$PATH"

# Instalar o plugin (o Claude Code baixa e instala via bun automaticamente)
PLUGIN_SAIDA=$("$CLAUDE_BIN" --dangerously-skip-permissions \
  plugin install telegram@claude-plugins-official 2>&1)
PLUGIN_EXIT=$?

if [ $PLUGIN_EXIT -ne 0 ]; then
  # Verificar se já estava instalado (não é erro real)
  if echo "$PLUGIN_SAIDA" | grep -qi "already installed\|já instalado"; then
    aviso "Plugin já estava instalado — OK"
  else
    aviso "Instalação do plugin retornou erro: $PLUGIN_SAIDA"
    aviso "Tentando continuar mesmo assim..."
  fi
fi

# Garantir que o plugin está habilitado no settings.json
SETTINGS_FILE="$HOME/.claude/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
  echo '{"enabledPlugins":{"telegram@claude-plugins-official":true}}' > "$SETTINGS_FILE"
else
  # Adicionar enabledPlugins se não existir, ou habilitar o plugin se já existir
  python3 - "$SETTINGS_FILE" << 'PYSETTINGS'
import json, sys
f = sys.argv[1]
with open(f) as fh:
  data = json.load(fh)
plugins = data.setdefault('enabledPlugins', {})
plugins['telegram@claude-plugins-official'] = True
with open(f, 'w') as fh:
  json.dump(data, fh, indent=2)
print('settings.json atualizado')
PYSETTINGS
fi

# Verificar que o plugin foi instalado de fato
PLUGIN_DIR="$HOME/.claude/plugins/cache/claude-plugins-official/telegram"
if [ -d "$PLUGIN_DIR" ]; then
  PLUGIN_VER=$(ls "$PLUGIN_DIR" 2>/dev/null | tail -1)
  sucesso "Plugin Telegram instalado (versão $PLUGIN_VER)"
else
  aviso "Diretório do plugin não encontrado em $PLUGIN_DIR"
  aviso "O plugin pode não ter instalado corretamente."
  aviso "Após a instalação, rode manualmente: claude plugin install telegram@claude-plugins-official"
fi

# ── Workspace de memória ─────────────────────────────────────
info "Criando workspace de memória..."

# SOUL.md
cat > "$HOME/.claude/workspace/SOUL.md" << SOUL
# Identidade do Assistente

Você é o assistente pessoal de $NOME_USUARIO, rodando 24/7 via Telegram.

## Propósito

Ser o braço direito operacional de $NOME_USUARIO — executar tarefas no computador, lembrar contexto entre conversas, e agir de forma proativa quando necessário.

## Princípios de operação

- **Ação direta:** quando $NOME_USUARIO pede algo concreto, faz — sem pedir confirmação para coisas óbvias
- **Memória real:** anota tudo importante no diário e atualiza NOW.md
- **Proativo:** verifica HEARTBEAT.md regularmente e age quando há pendências
- **Local-first:** dados ficam no disco, não dependem de nuvem
- **Honesto:** se não sabe ou não consegue, diz diretamente

## Comunicação

- Português do Brasil, direto ao ponto
- Sem introduções desnecessárias
- Confirmações curtas: "Feito.", "Rodando agora."
SOUL

# USER.md
cat > "$HOME/.claude/workspace/USER.md" << USERMD
# $NOME_USUARIO — Perfil do Usuário

## Identificação

- **Nome:** $NOME_USUARIO
- **Contato Telegram ID:** $TELEGRAM_CHAT_ID

## Preferências de comunicação

- Direto, sem enrolação
- Prefere ação a explicação longa
- Português do Brasil

## Notas

*(Atualize conforme aprender mais sobre $NOME_USUARIO)*
USERMD

# MEMORY.md
cat > "$HOME/.claude/workspace/MEMORY.md" << MEMMD
# Memória de Longo Prazo

*Atualizado automaticamente pelo assistente.*

## Setup técnico

- Assistente rodando via \`claude --channels plugin:telegram@claude-plugins-official\`
- Workspace: \`~/.claude/workspace/\`
- Heartbeat a cada ${HEARTBEAT_INTERVALO} minutos

## Sobre $NOME_USUARIO

*(Será preenchido conforme as conversas acontecerem)*
MEMMD

# NOW.md
cat > "$HOME/.claude/workspace/NOW.md" << NOWMD
# Foco Atual

*Arquivo efêmero — o que está acontecendo agora.*

## Em andamento

*(Nada ainda — assistente recém configurado)*

## Aguardando

*(Nada)*
NOWMD

# HEARTBEAT.md
cat > "$HOME/.claude/workspace/HEARTBEAT.md" << HBMD
# Heartbeat — Tarefas Proativas

*O assistente verifica este arquivo a cada ${HEARTBEAT_INTERVALO} minutos.*

## Checks automáticos (sempre)

- Verificar se há diários com mais de 7 dias para consolidar em MEMORY.md
- Verificar saúde do bot

## Tarefas pendentes

*(Adicione aqui tarefas para execução autônoma)*
HBMD

sucesso "Workspace de memória criado"

# ── gerar-contexto.sh ────────────────────────────────────────
info "Criando script de geração de contexto..."
cat > "$HOME/.claude/gerar-contexto.sh" << 'GERCTX'
#!/bin/bash
WORKSPACE="$HOME/.claude/workspace"
BRIEF="$WORKSPACE/BRIEF.md"
DATA_HOJE=$(date +%Y-%m-%d)
HORA_ATUAL=$(date +%H:%M)
DIARIO_HOJE="$WORKSPACE/diario/$DATA_HOJE.md"

{
  echo "# Contexto do Assistente"
  echo "*Compilado em $DATA_HOJE às $HORA_ATUAL*"
  echo ""
  echo "## Identidade"
  [ -f "$WORKSPACE/SOUL.md" ] && cat "$WORKSPACE/SOUL.md"
  echo ""
  echo "## Usuário"
  [ -f "$WORKSPACE/USER.md" ] && cat "$WORKSPACE/USER.md"
  echo ""
  echo "## Foco atual"
  [ -f "$WORKSPACE/NOW.md" ] && cat "$WORKSPACE/NOW.md" || echo "*(nada)*"
  echo ""
  echo "## Memória de longo prazo"
  [ -f "$WORKSPACE/MEMORY.md" ] && cat "$WORKSPACE/MEMORY.md" || echo "*(vazia)*"
  echo ""
  echo "## Diário de hoje ($DATA_HOJE)"
  [ -f "$DIARIO_HOJE" ] && cat "$DIARIO_HOJE" || echo "*(nenhum registro ainda)*"
  echo ""
} > "$BRIEF"

echo "[$(date +%H:%M)] BRIEF.md gerado" >&2
GERCTX
chmod +x "$HOME/.claude/gerar-contexto.sh"
sucesso "gerar-contexto.sh criado"

# ── start-telegram-bot.sh ────────────────────────────────────
info "Criando wrapper do bot..."
cat > "$HOME/.claude/start-telegram-bot.sh" << STARTBOT
#!/bin/bash
# Wrapper do Claude Code Telegram Bot
# Mata zumbis, gera BRIEF.md, sobe com PTY

pkill -f "bun run.*--cwd.*telegram" 2>/dev/null || true
pkill -f "bun.*server\.ts" 2>/dev/null || true
sleep 2

# Gerar contexto compilado antes de subir
bash "$HOME/.claude/gerar-contexto.sh"

# Subir com pseudo-terminal (PTY via script)
exec /usr/bin/script -q /dev/null \\
    $CLAUDE_BIN \\
    --dangerously-skip-permissions \\
    --channels plugin:telegram@claude-plugins-official
STARTBOT
chmod +x "$HOME/.claude/start-telegram-bot.sh"
sucesso "start-telegram-bot.sh criado"

# ── heartbeat-telegram.sh ────────────────────────────────────
info "Criando script de heartbeat..."
cat > "$HOME/.claude/heartbeat-telegram.sh" << 'HEARTBEAT'
#!/bin/bash
WORKSPACE="$HOME/.claude/workspace"
MARKER_CONSOLIDACAO="$WORKSPACE/.ultima-consolidacao"
DIAS_ENTRE_CONSOLIDACOES=3

ENV_FILE="$HOME/.claude/channels/telegram/.env"
[ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs)

CHAT_ID=$(python3 -c "
import json
try:
  d = json.load(open('$HOME/.claude/channels/telegram/access.json'))
  print(d.get('allowFrom', [''])[0])
except: print('')
" 2>/dev/null)

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
  echo "[$(date +%H:%M)] heartbeat: config ausente" >&2; exit 1
fi

bash "$HOME/.claude/gerar-contexto.sh"

HORA=$(date +%H:%M)
HOJE=$(date +%Y-%m-%d)
CONSOLIDAR=false

if [ ! -f "$MARKER_CONSOLIDACAO" ]; then
  CONSOLIDAR=true
else
  ULTIMA=$(cat "$MARKER_CONSOLIDACAO" 2>/dev/null)
  DIAS_PASSADOS=$(python3 -c "
from datetime import date
try:
  print((date.fromisoformat('$HOJE') - date.fromisoformat('$ULTIMA')).days)
except: print(999)
" 2>/dev/null)
  [ "$DIAS_PASSADOS" -ge "$DIAS_ENTRE_CONSOLIDACOES" ] 2>/dev/null && CONSOLIDAR=true
fi

if [ "$CONSOLIDAR" = true ]; then
  ULTIMA_DATA=$(cat "$MARKER_CONSOLIDACAO" 2>/dev/null || echo "nunca")
  DIARIOS=$(ls "$WORKSPACE/diario/"*.md 2>/dev/null | sort | tail -7 | while read f; do echo "- $(basename $f)"; done)
  [ -z "$DIARIOS" ] && DIARIOS="(nenhum diário ainda)"
  MENSAGEM="[CONSOLIDAR MEMÓRIA] ${HORA}

Última consolidação: ${ULTIMA_DATA}
Diários disponíveis:
${DIARIOS}

Instruções:
1. Leia cada diário listado
2. Extraia aprendizados DURÁVEIS (fatos sobre o usuário, preferências, padrões, projetos)
3. Ignore eventos pontuais sem valor futuro
4. Acrescente em ~/.claude/workspace/MEMORY.md — nunca apague o que já existe
5. Responda apenas: Memória consolidada."
  echo "$HOJE" > "$MARKER_CONSOLIDACAO"
  echo "[$(date +%H:%M)] consolidação de memória disparada" >&2
else
  MENSAGEM="[HEARTBEAT] ${HORA}"
fi

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${MENSAGEM}" >/dev/null

echo "[$(date +%H:%M)] heartbeat enviado (consolidar=$CONSOLIDAR)" >&2
HEARTBEAT
chmod +x "$HOME/.claude/heartbeat-telegram.sh"
sucesso "heartbeat-telegram.sh criado"

# ── Scripts de voz (TTS + transcrição) ──────────────────────
info "Criando scripts de voz..."

cat > "$HOME/.claude/transcrever-audio.sh" << 'TRANSCREVER'
#!/bin/bash
# Transcreve áudio para texto usando Whisper local (gratuito)
FILE="$1"
[ -z "$FILE" ] || [ ! -f "$FILE" ] && { echo "Erro: arquivo não encontrado: $FILE" >&2; exit 1; }
TIMESTAMP=$(date +%s%N)
WAV="/tmp/whisper-input-${TIMESTAMP}.wav"
OUTPUT_DIR="/tmp/whisper-out-${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"
ffmpeg -i "$FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" -y 2>/dev/null
[ ! -f "$WAV" ] && { echo "Erro: falha ao converter áudio" >&2; exit 1; }
whisper "$WAV" --model small --language Portuguese --output_format txt --output_dir "$OUTPUT_DIR" --verbose False 2>/dev/null
BASENAME=$(basename "$WAV" .wav)
RESULTADO="$OUTPUT_DIR/${BASENAME}.txt"
[ -f "$RESULTADO" ] && cat "$RESULTADO" || { echo "Erro: Whisper não gerou saída" >&2; exit 1; }
rm -f "$WAV"; rm -rf "$OUTPUT_DIR"
TRANSCREVER

cat > "$HOME/.claude/falar.sh" << 'FALAR'
#!/bin/bash
# Converte texto em voz (Piper TTS, voz faber PT-BR) e envia pelo Telegram
# Uso: bash falar.sh "<texto>" <chat_id>
TEXTO="$1"
CHAT_ID="$2"
TIMESTAMP=$(date +%s%N)
WAV_TEMP="/tmp/piper-${TIMESTAMP}.wav"
OGG_SAIDA="/tmp/voz-${TIMESTAMP}.ogg"
PIPER_BIN="/opt/homebrew/bin/piper"
MODELO_VOZ="$HOME/piper-voices/pt_BR-faber-medium.onnx"
[ -z "$TEXTO" ] && { echo "Uso: bash falar.sh '<texto>' [chat_id]" >&2; exit 1; }
[ ! -f "$MODELO_VOZ" ] && { echo "Erro: modelo de voz não encontrado em $MODELO_VOZ" >&2; exit 1; }
echo "$TEXTO" | "$PIPER_BIN" --model "$MODELO_VOZ" --output_file "$WAV_TEMP" 2>/dev/null
[ ! -f "$WAV_TEMP" ] && { echo "Erro: Piper não gerou áudio" >&2; exit 1; }
ffmpeg -i "$WAV_TEMP" -c:a libopus -b:a 32k -vbr on "$OGG_SAIDA" -y 2>/dev/null
rm -f "$WAV_TEMP"
[ ! -f "$OGG_SAIDA" ] && { echo "Erro: ffmpeg falhou" >&2; exit 1; }
if [ -n "$CHAT_ID" ]; then
  ENV_FILE="$HOME/.claude/channels/telegram/.env"
  [ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs)
  [ -n "$TELEGRAM_BOT_TOKEN" ] && curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendVoice" \
    -F "chat_id=${CHAT_ID}" -F "voice=@${OGG_SAIDA}" >/dev/null 2>&1
fi
echo "$OGG_SAIDA"
FALAR

chmod +x "$HOME/.claude/transcrever-audio.sh" "$HOME/.claude/falar.sh"
sucesso "Scripts de voz criados (transcrever-audio.sh + falar.sh)"

# ── LaunchAgent principal ────────────────────────────────────
info "Criando LaunchAgent do bot..."
LAUNCHAGENT_DIR="$HOME/Library/LaunchAgents"
mkdir -p "$LAUNCHAGENT_DIR"

cat > "$LAUNCHAGENT_DIR/com.$(echo $NOME_USUARIO | tr '[:upper:]' '[:lower:]').claude-telegram.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.$(echo $NOME_USUARIO | tr '[:upper:]' '[:lower:]').claude-telegram</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$HOME/.claude/start-telegram-bot.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.bun/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>$HOME</string>
        <key>ANTHROPIC_API_KEY</key>
        <string>$ANTHROPIC_API_KEY</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/claude-telegram.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/claude-telegram.log</string>
</dict>
</plist>
PLIST
sucesso "LaunchAgent principal criado"

# ── LaunchAgent heartbeat ────────────────────────────────────
info "Criando LaunchAgent do heartbeat..."
cat > "$LAUNCHAGENT_DIR/com.$(echo $NOME_USUARIO | tr '[:upper:]' '[:lower:]').claude-telegram-heartbeat.plist" << HBPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.$(echo $NOME_USUARIO | tr '[:upper:]' '[:lower:]').claude-telegram-heartbeat</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$HOME/.claude/heartbeat-telegram.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.bun/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
    <key>StartInterval</key>
    <integer>$HEARTBEAT_SEGUNDOS</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>$HOME/Library/Logs/claude-telegram-heartbeat.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/Library/Logs/claude-telegram-heartbeat.log</string>
</dict>
</plist>
HBPLIST
sucesso "LaunchAgent heartbeat criado"

# ── Adicionar instrução ao CLAUDE.md ─────────────────────────
info "Configurando instruções do assistente no CLAUDE.md..."
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
if ! grep -q "ASSISTENTE PESSOAL REMOTO" "$CLAUDE_MD" 2>/dev/null; then
  cat >> "$CLAUDE_MD" << 'CLAUDEMD'

## ASSISTENTE PESSOAL REMOTO

### Ao iniciar uma sessão (primeira mensagem recebida)

1. Leia `~/.claude/workspace/BRIEF.md` — contexto compilado (identidade, usuário, foco atual, memória, diário de hoje)
2. Confirme internamente que carregou o contexto

### Ao receber `[HEARTBEAT]`

1. Leia `~/.claude/workspace/HEARTBEAT.md`
2. Leia o diário de hoje em `~/.claude/workspace/diario/YYYY-MM-DD.md`
3. Execute tarefas pendentes marcadas com `- [ ]`
4. Marque como feito: `- [x] tarefa (feito às HH:MM)`
5. Envie resposta via `reply` apenas se houver algo relevante
6. Se não houver nada pendente, não responda

### Ao receber `[CONSOLIDAR MEMÓRIA]`

A mensagem lista os diários disponíveis. Siga exatamente:

1. Leia cada arquivo de diário listado na mensagem
2. Para cada diário, identifique aprendizados **duráveis**:
   - Fatos sobre o usuário (o que gosta, como trabalha, o que está construindo)
   - Preferências descobertas ("prefere resposta curta", "trabalha de manhã")
   - Decisões importantes tomadas
   - Padrões de comportamento observados
   - Contexto de projetos em andamento
3. **Ignore** eventos pontuais sem valor futuro (ex: "pediu para abrir um arquivo")
4. Acrescente os aprendizados em `~/.claude/workspace/MEMORY.md` nas seções corretas
5. **Nunca apague** nada que já existe no MEMORY.md — só acrescente
6. Responda apenas: `Memória consolidada.` (processo silencioso, sem detalhes)

### Mensagens de voz recebidas

Ao receber mensagem com `attachment_kind: voice` ou `attachment_kind: audio`:
1. Chame `download_attachment` com o `attachment_file_id` para obter o arquivo local
2. Transcreva: execute `bash ~/.claude/transcrever-audio.sh <caminho_do_arquivo>`
3. Use o texto transcrito como se fosse a mensagem do usuário
4. Decida se responde em áudio ou texto (regra abaixo)

### Regra: quando responder em áudio

**Responda em áudio SE:**
- O usuário enviou a mensagem atual como áudio, E
- A resposta é conversacional (pergunta geral, atualização, conselho, confirmação)

**Responda em texto SE a resposta contiver:**
- Código ou comandos de terminal
- URLs ou links
- Listas técnicas longas
- Instruções passo a passo com detalhes técnicos

**Para gerar resposta em áudio:**
```
ARQUIVO=$(bash ~/.claude/falar.sh "texto da resposta" CHAT_ID_AQUI)
```
O script já envia pelo Telegram via sendVoice. Não use `reply` para áudio.

### Durante as conversas

**Diário:** Ao final de turnos significativos, appende em `~/.claude/workspace/diario/YYYY-MM-DD.md`:
```
[HH:MM] descrição breve
```

**NOW.md:** Atualize com contexto em andamento e threads abertas.

**MEMORY.md:** A cada ~3 dias, consolide aprendizados duráveis.

CLAUDEMD
  sucesso "CLAUDE.md atualizado"
else
  aviso "CLAUDE.md já tem a seção do assistente — não alterado"
fi

# ── Ativar LaunchAgents ──────────────────────────────────────
info "Ativando LaunchAgents..."
NOME_LOWER=$(echo "$NOME_USUARIO" | tr '[:upper:]' '[:lower:]')
launchctl unload "$LAUNCHAGENT_DIR/com.${NOME_LOWER}.claude-telegram.plist" 2>/dev/null || true
launchctl load "$LAUNCHAGENT_DIR/com.${NOME_LOWER}.claude-telegram.plist"
launchctl unload "$LAUNCHAGENT_DIR/com.${NOME_LOWER}.claude-telegram-heartbeat.plist" 2>/dev/null || true
launchctl load "$LAUNCHAGENT_DIR/com.${NOME_LOWER}.claude-telegram-heartbeat.plist"
sucesso "LaunchAgents ativos"

# ── Conclusão ─────────────────────────────────────────────────
echo ""
echo "============================================================"
echo -e "${VERDE}  Instalação concluída!${SEM_COR}"
echo "============================================================"
echo ""
echo "O assistente está subindo agora. Em ~30 segundos,"
echo "mande qualquer mensagem para o bot no Telegram."
echo ""
echo "Arquivos criados:"
echo "  ~/.claude/workspace/           → memória do assistente"
echo "  ~/.claude/gerar-contexto.sh    → compila workspace em BRIEF.md"
echo "  ~/.claude/start-telegram-bot.sh"
echo "  ~/.claude/heartbeat-telegram.sh"
echo "  ~/.claude/transcrever-audio.sh → Whisper (voz → texto)"
echo "  ~/.claude/falar.sh             → Piper TTS faber (texto → voz)"
echo "  ~/piper-voices/                → modelo de voz faber PT-BR"
echo "  ~/Library/LaunchAgents/com.${NOME_LOWER}.claude-telegram.plist"
echo "  ~/Library/LaunchAgents/com.${NOME_LOWER}.claude-telegram-heartbeat.plist"
echo ""
echo "Logs:"
echo "  ~/Library/Logs/claude-telegram.log"
echo "  ~/Library/Logs/claude-telegram-heartbeat.log"
echo ""
echo "Heartbeat: a cada ${HEARTBEAT_INTERVALO} minutos"
echo ""
