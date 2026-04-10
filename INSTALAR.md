# Prompt de Instalação — Cole no Claude Code

Copie o bloco abaixo e cole diretamente no Claude Code para iniciar a instalação guiada.

---

```
Quero que você instale o Assistente Pessoal Remoto no meu Mac. É um sistema que me permite conversar com você pelo Telegram, mesmo com o computador fechado em segundo plano. Você responde em texto e em áudio, lembra de mim ao longo do tempo, e pode executar tarefas automaticamente.

Vamos fazer isso juntos, passo a passo. Me faça as perguntas necessárias, um item de cada vez, e cuide de tudo que puder fazer sozinho sem me perguntar.

**Siga exatamente esta ordem:**

---

## ETAPA 1 — Criar o bot no Telegram

Explique ao usuário o que é o BotFather (o robô oficial do Telegram que cria bots) e peça para ele:

1. Abrir o Telegram no celular ou computador
2. Pesquisar por @BotFather e iniciar conversa
3. Enviar /newbot
4. Escolher um nome para o bot (ex: "Meu Assistente")
5. Escolher um username para o bot (precisa terminar em "bot", ex: "meu_assistente_bot")
6. Copiar o token que o BotFather vai enviar (formato: 1234567890:ABCdef...)

Aguarde o usuário colar o token aqui antes de continuar.

---

## ETAPA 2 — Descobrir o ID do Telegram

Explique que você precisa saber o ID numérico do Telegram do usuário (diferente do @username). Instrua:

1. No Telegram, pesquisar por @userinfobot
2. Enviar qualquer mensagem para ele
3. Ele vai responder com as informações — copiar o número que aparece em "Id:"

Aguarde o usuário colar o ID antes de continuar.

---

## ETAPA 3 — Chave da API da Anthropic

Explique que a chave da API é o que permite que o assistente use a inteligência do Claude. Instrua:

1. Acessar console.anthropic.com
2. Fazer login ou criar conta
3. Ir em "API Keys" e criar uma nova chave
4. Copiar a chave (começa com "sk-ant-...")

Aguarde o usuário colar a chave antes de continuar.

---

## ETAPA 4 — Nome do usuário

Pergunte qual nome o assistente deve usar para se referir ao usuário (ex: "João", "Ana", "Rafa").

---

## ETAPA 5 — Instalação automática

Com todas as informações coletadas, execute cada passo abaixo. Use as ferramentas do Claude Code (Bash, Write, Edit) para fazer tudo. Informe o usuário o que está fazendo em cada etapa com linguagem simples.

### 5.1 — Verificar e instalar Homebrew
Verifique se o Homebrew (gerenciador de pacotes do Mac — como uma loja de apps pelo terminal) está instalado. Se não estiver, instale com:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 5.2 — Instalar ffmpeg
O ffmpeg converte arquivos de áudio entre formatos. Instale com:
```bash
brew install ffmpeg
```

### 5.3 — Instalar Piper TTS
O Piper é o sistema que gera a voz do assistente. Instale com:
```bash
brew install piper-tts
```

### 5.4 — Baixar a voz brasileira (Faber)
Esta é a voz em português do Brasil que o assistente vai usar:
```bash
mkdir -p "$HOME/piper-voices"
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx" -o "$HOME/piper-voices/pt_BR-faber-medium.onnx"
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json" -o "$HOME/piper-voices/pt_BR-faber-medium.onnx.json"
```

### 5.5 — Instalar Whisper (transcrição de voz)
O Whisper transcreve mensagens de voz que o usuário enviar:
```bash
pip3 install openai-whisper
```
Se pip3 não estiver disponível, instale via brew: `brew install python` e tente novamente.

Depois baixe o modelo de transcrição:
```bash
python3 -c "import whisper; whisper.load_model('small')"
```

### 5.6 — Instalar Bun
O Bun é necessário para o plugin do Telegram funcionar:
```bash
curl -fsSL https://bun.sh/install | bash
export PATH="$HOME/.bun/bin:$PATH"
```

### 5.7 — Verificar Claude Code
Verifique se o Claude Code está instalado com `which claude`. Se não estiver, instale:
```bash
npm install -g @anthropic-ai/claude-code
```

### 5.8 — Instalar plugin Telegram
```bash
export PATH="$HOME/.bun/bin:$PATH"
claude --dangerously-skip-permissions mcp install @claude-plugins-official/telegram 2>&1 | tail -3
```

### 5.9 — Configurar credenciais do Telegram
Crie os arquivos de configuração com o token e o ID que o usuário forneceu:

Crie `~/.claude/channels/telegram/.env` com:
```
TELEGRAM_BOT_TOKEN=<token do usuário>
```

Crie `~/.claude/channels/telegram/access.json` com:
```json
{
  "allowFrom": ["<id do usuário>"]
}
```

Ajuste permissões:
```bash
chmod 600 ~/.claude/channels/telegram/.env
chmod 600 ~/.claude/channels/telegram/access.json
mkdir -p ~/.claude/channels/telegram/approved
```

### 5.10 — Limpar webhook do bot
Verifique e limpe qualquer webhook ativo (evita conflito se o bot foi usado em outro lugar):
```bash
curl -s "https://api.telegram.org/bot<TOKEN>/deleteWebhook"
```

### 5.11 — Criar estrutura do workspace
Crie os diretórios e arquivos de memória do assistente:
```bash
mkdir -p ~/.claude/workspace/diario
```

Crie os arquivos: SOUL.md, USER.md, MEMORY.md, NOW.md, HEARTBEAT.md e BRIEF.md no diretório `~/.claude/workspace/`, com o nome do usuário substituído corretamente.

**SOUL.md** — identidade do assistente:
```
# Identidade do Assistente

Você é um assistente pessoal inteligente, ativo 24/7 via Telegram.
Você é direto, prestativo e aprende com o tempo.
Você conhece o usuário pelo nome e adapta seu estilo ao contexto.
Você pode executar tarefas no computador do usuário remotamente.
Você fala em português do Brasil.
```

**USER.md** — perfil do usuário (substitua NOME_USUARIO pelo nome real):
```
# Perfil do Usuário

- Nome: NOME_USUARIO
- Sistema: Mac
- Idioma preferido: Português do Brasil
- Canal de comunicação: Telegram
```

**MEMORY.md** — memória de longo prazo (começa vazia):
```
# Memória do Assistente

## Sobre o usuário

## Preferências descobertas

## Projetos em andamento

## Decisões importantes
```

**NOW.md** — foco atual (começa vazio):
```
# Foco Atual

(nenhum em andamento)
```

**HEARTBEAT.md** — tarefas proativas:
```
# Tarefas do Heartbeat

- [ ] Verificar se há alguma mensagem importante pendente
```

**BRIEF.md** — deixe vazio por agora (será gerado automaticamente):
```
(será gerado automaticamente na primeira execução)
```

### 5.12 — Criar scripts de funcionamento
Crie os seguintes scripts em `~/.claude/`:

**gerar-contexto.sh** — compila o contexto antes de cada sessão:
```bash
#!/bin/bash
WORKSPACE="$HOME/.claude/workspace"
BRIEF="$WORKSPACE/BRIEF.md"

{
  echo "# BRIEF — Contexto do Assistente"
  echo "Gerado em: $(date '+%Y-%m-%d %H:%M')"
  echo ""
  [ -f "$WORKSPACE/SOUL.md" ]      && cat "$WORKSPACE/SOUL.md" && echo ""
  [ -f "$WORKSPACE/USER.md" ]      && cat "$WORKSPACE/USER.md" && echo ""
  [ -f "$WORKSPACE/MEMORY.md" ]    && cat "$WORKSPACE/MEMORY.md" && echo ""
  [ -f "$WORKSPACE/NOW.md" ]       && cat "$WORKSPACE/NOW.md" && echo ""
  [ -f "$WORKSPACE/HEARTBEAT.md" ] && cat "$WORKSPACE/HEARTBEAT.md" && echo ""
  HOJE=$(date +%Y-%m-%d)
  DIARIO="$WORKSPACE/diario/${HOJE}.md"
  [ -f "$DIARIO" ] && echo "## Diário de Hoje" && cat "$DIARIO"
} > "$BRIEF"
```

**falar.sh** — converte texto em voz e envia pelo Telegram:
```bash
#!/bin/bash
TEXTO="$1"
CHAT_ID="$2"
TIMESTAMP=$(date +%s%N)
WAV_TEMP="/tmp/piper-${TIMESTAMP}.wav"
OGG_SAIDA="/tmp/voz-${TIMESTAMP}.ogg"
PIPER_BIN="/opt/homebrew/bin/piper"
MODELO_VOZ="$HOME/piper-voices/pt_BR-faber-medium.onnx"

[ -z "$TEXTO" ] && echo "Uso: bash falar.sh '<texto>' [chat_id]" >&2 && exit 1
[ ! -f "$MODELO_VOZ" ] && echo "Erro: modelo de voz não encontrado" >&2 && exit 1

echo "$TEXTO" | "$PIPER_BIN" --model "$MODELO_VOZ" --output_file "$WAV_TEMP" 2>/dev/null
[ ! -f "$WAV_TEMP" ] && echo "Erro: Piper não gerou áudio" >&2 && exit 1

ffmpeg -i "$WAV_TEMP" -c:a libopus -b:a 32k -vbr on "$OGG_SAIDA" -y 2>/dev/null
rm -f "$WAV_TEMP"
[ ! -f "$OGG_SAIDA" ] && echo "Erro: ffmpeg não converteu" >&2 && exit 1

if [ -n "$CHAT_ID" ]; then
  ENV_FILE="$HOME/.claude/channels/telegram/.env"
  [ -f "$ENV_FILE" ] && export $(grep -v '^#' "$ENV_FILE" | xargs)
  [ -n "$TELEGRAM_BOT_TOKEN" ] && curl -s -X POST \
    "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendVoice" \
    -F "chat_id=${CHAT_ID}" -F "voice=@${OGG_SAIDA}" >/dev/null 2>&1
fi

echo "$OGG_SAIDA"
```

**transcrever-audio.sh** — transcreve mensagens de voz:
```bash
#!/bin/bash
FILE="$1"
[ -z "$FILE" ] || [ ! -f "$FILE" ] && echo "Erro: arquivo não encontrado: $FILE" >&2 && exit 1

TIMESTAMP=$(date +%s%N)
WAV="/tmp/whisper-input-${TIMESTAMP}.wav"
OUTPUT_DIR="/tmp/whisper-out-${TIMESTAMP}"
mkdir -p "$OUTPUT_DIR"

ffmpeg -i "$FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" -y 2>/dev/null
[ ! -f "$WAV" ] && echo "Erro: falha ao converter áudio" >&2 && exit 1

whisper "$WAV" --model small --language Portuguese --output_format txt --output_dir "$OUTPUT_DIR" --verbose False 2>/dev/null

BASENAME=$(basename "$WAV" .wav)
RESULTADO="$OUTPUT_DIR/${BASENAME}.txt"
[ -f "$RESULTADO" ] && cat "$RESULTADO" || echo "Erro: Whisper não gerou saída" >&2

rm -f "$WAV"
rm -rf "$OUTPUT_DIR"
```

**start-telegram-bot.sh** — inicia o bot com PTY (terminal virtual):
```bash
#!/bin/bash
pkill -f "bun.*server" 2>/dev/null || true
sleep 1
bash "$HOME/.claude/gerar-contexto.sh"
exec /usr/bin/script -q /dev/null claude --dangerously-skip-permissions --channels plugin:telegram@claude-plugins-official
```

**heartbeat-telegram.sh** — verifica tarefas a cada 30 minutos:
```bash
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

[ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$CHAT_ID" ] && exit 1

bash "$HOME/.claude/gerar-contexto.sh"

CONSOLIDAR=false
HOJE=$(date +%Y-%m-%d)

if [ ! -f "$MARKER_CONSOLIDACAO" ]; then
  CONSOLIDAR=true
else
  ULTIMA=$(cat "$MARKER_CONSOLIDACAO" 2>/dev/null)
  DIAS_PASSADOS=$(python3 -c "
from datetime import date
try:
  ultima = date.fromisoformat('$ULTIMA')
  hoje = date.fromisoformat('$HOJE')
  print((hoje - ultima).days)
except: print(999)
" 2>/dev/null)
  [ "$DIAS_PASSADOS" -ge "$DIAS_ENTRE_CONSOLIDACOES" ] 2>/dev/null && CONSOLIDAR=true
fi

HORA=$(date +%H:%M)

if [ "$CONSOLIDAR" = true ]; then
  ULTIMA_DATA=$(cat "$MARKER_CONSOLIDACAO" 2>/dev/null || echo "nunca")
  DIARIOS=$(ls "$WORKSPACE/diario/"*.md 2>/dev/null | sort | tail -7 | while read f; do echo "- $(basename $f)"; done)
  [ -z "$DIARIOS" ] && DIARIOS="(nenhum diário encontrado ainda)"
  MENSAGEM="[CONSOLIDAR MEMÓRIA] ${HORA}

Última consolidação: ${ULTIMA_DATA}
Diários disponíveis:
${DIARIOS}

Instruções:
1. Leia cada diário listado
2. Extraia aprendizados DURÁVEIS sobre o usuário
3. Acrescente em ~/.claude/workspace/MEMORY.md
4. Nunca apague o que já existe
5. Responda apenas: Memória consolidada."
  echo "$HOJE" > "$MARKER_CONSOLIDACAO"
else
  MENSAGEM="[HEARTBEAT] ${HORA}"
fi

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${CHAT_ID}" \
  --data-urlencode "text=${MENSAGEM}" >/dev/null 2>&1
```

Torne todos os scripts executáveis:
```bash
chmod +x ~/.claude/gerar-contexto.sh ~/.claude/falar.sh ~/.claude/transcrever-audio.sh ~/.claude/start-telegram-bot.sh ~/.claude/heartbeat-telegram.sh
```

### 5.13 — Criar LaunchAgents (serviços em segundo plano)
Descubra o nome do usuário do Mac com `whoami` e use no lugar de USUARIO_MAC abaixo.

Crie `~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.USUARIO_MAC.claude-telegram</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USUARIO_MAC/.claude/start-telegram-bot.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/Users/USUARIO_MAC/.bun/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>/Users/USUARIO_MAC</string>
    </dict>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/USUARIO_MAC/Library/Logs/claude-telegram.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USUARIO_MAC/Library/Logs/claude-telegram.log</string>
    <key>ThrottleInterval</key>
    <integer>30</integer>
</dict>
</plist>
```

Crie `~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram-heartbeat.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.USUARIO_MAC.claude-telegram-heartbeat</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USUARIO_MAC/.claude/heartbeat-telegram.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/Users/USUARIO_MAC/.bun/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key>
        <string>/Users/USUARIO_MAC</string>
    </dict>
    <key>StartInterval</key>
    <integer>1800</integer>
    <key>RunAtLoad</key>
    <false/>
    <key>StandardOutPath</key>
    <string>/Users/USUARIO_MAC/Library/Logs/claude-telegram-heartbeat.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/USUARIO_MAC/Library/Logs/claude-telegram-heartbeat.log</string>
</dict>
</plist>
```

### 5.14 — Ativar os serviços
```bash
launchctl unload ~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram.plist

launchctl unload ~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram-heartbeat.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.USUARIO_MAC.claude-telegram-heartbeat.plist
```

### 5.15 — Atualizar CLAUDE.md
Verifique se `~/.claude/CLAUDE.md` existe. Se não existir, crie. Se existir, adicione no início (sem apagar o que já existe) a seguinte seção:

```markdown
## ASSISTENTE PESSOAL REMOTO

### Ao iniciar uma sessão (primeira mensagem recebida)
1. Leia `~/.claude/workspace/BRIEF.md` — contexto compilado

### Ao receber [HEARTBEAT]
1. Leia `~/.claude/workspace/HEARTBEAT.md`
2. Leia `~/.claude/workspace/diario/YYYY-MM-DD.md` (data de hoje)
3. Execute tarefas pendentes marcadas com `- [ ]`
4. Marque como feito: `- [x] tarefa (feito às HH:MM)`
5. Se houver algo relevante para o usuário, envie via `reply`
6. Se não houver nada pendente, não responda

### Ao receber [CONSOLIDAR MEMÓRIA]
1. Leia cada diário listado na mensagem
2. Extraia aprendizados duráveis sobre o usuário
3. Acrescente em `~/.claude/workspace/MEMORY.md`
4. Nunca apague o que já existe
5. Responda apenas: `Memória consolidada.`

### Mensagens de voz recebidas
1. Chame `download_attachment` com o `attachment_file_id`
2. Execute `bash ~/.claude/transcrever-audio.sh <arquivo>`
3. Use o texto como mensagem do usuário

### Regra: quando responder em áudio
Responda em áudio SE: usuário enviou áudio E resposta é conversacional.
Responda em texto SE: há código, URLs, listas técnicas ou instruções detalhadas.
Para gerar áudio: `bash ~/.claude/falar.sh "texto" <chat_id>`

### Durante as conversas
- Escreva no diário: `~/.claude/workspace/diario/YYYY-MM-DD.md`
- Atualize NOW.md quando iniciar tarefas longas
```

---

## ETAPA 6 — Verificação final

1. Verifique se todos os arquivos foram criados corretamente
2. Teste o bot: envie uma mensagem no Telegram para o bot criado
3. Se a resposta aparecer, a instalação foi um sucesso

Informe o usuário com uma mensagem clara de conclusão, incluindo:
- Nome do bot (@username)
- Que o assistente já está rodando em segundo plano
- Que ele pode enviar mensagens de texto e voz pelo Telegram

---

**Importante:** Se qualquer etapa falhar, diagnostique o erro, explique o que aconteceu em linguagem simples, e tente resolver antes de continuar. Nunca abandone a instalação por um erro sem tentar corrigi-lo.
```
