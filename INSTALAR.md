Quero que você instale o Assistente Pessoal Remoto no meu Mac. É um sistema que me permite conversar com você pelo Telegram, mesmo com o computador em segundo plano. Você responde em texto e em áudio, lembra de mim ao longo do tempo, e verifica tarefas automaticamente a cada 30 minutos.

Faça as perguntas uma de cada vez e cuide de tudo que puder fazer sozinho.

---

## PASSO 1 — Criar o bot no Telegram

Explique ao usuário o que é o BotFather (o robô oficial do Telegram que cria bots — como um cartório que registra bots) e peça para ele seguir estes passos agora:

1. Abrir o Telegram
2. Pesquisar por @BotFather e abrir a conversa
3. Enviar: /newbot
4. Quando pedir o nome, digitar qualquer nome (ex: "Meu Assistente")
5. Quando pedir o username, digitar algo terminando em "bot" (ex: "meu_assistente_bot")
6. O BotFather vai responder com um token — um código longo assim:
   1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ

Aguarde o usuário colar o token aqui antes de continuar.

---

## PASSO 2 — Descobrir o ID do Telegram

Explique que o ID é um número único da conta do Telegram (diferente do @username). Instrua:

1. No Telegram, pesquisar por @userinfobot
2. Enviar qualquer mensagem para ele (pode ser "oi")
3. Copiar o número que aparece em "Id:"

Aguarde o usuário colar o ID antes de continuar.

---

## PASSO 3 — Chave da API da Anthropic

Explique que sem essa chave o assistente não funciona — ela é como a senha de acesso ao cérebro do Claude. Instrua:

1. Acessar console.anthropic.com
2. Fazer login ou criar conta gratuita
3. Clicar em "API Keys" no menu lateral
4. Clicar em "Create Key", dar qualquer nome, e copiar a chave
5. A chave começa com: sk-ant-

Aguarde o usuário colar a chave antes de continuar.

---

## PASSO 4 — Nome do usuário

Pergunte: "Qual nome devo usar para me referir a você?" (ex: João, Ana, Rafa)

---

## PASSO 5 — Instalação

Com todas as informações coletadas, execute cada item abaixo em ordem. Informe o usuário o que está fazendo em cada etapa, com linguagem simples. Use as ferramentas do Claude Code (Bash, Write) para executar tudo.

### 5.1 Homebrew
Verifique com `which brew`. Se não estiver instalado:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Após instalar no Apple Silicon, adicione ao PATH:
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 5.2 ffmpeg
```bash
brew install ffmpeg
```

### 5.3 Piper TTS (voz do assistente)
```bash
brew install piper-tts
```

### 5.4 Voz brasileira Faber
```bash
mkdir -p "$HOME/piper-voices"
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx" -o "$HOME/piper-voices/pt_BR-faber-medium.onnx"
curl -L "https://huggingface.co/rhasspy/piper-voices/resolve/main/pt/pt_BR/faber/medium/pt_BR-faber-medium.onnx.json" -o "$HOME/piper-voices/pt_BR-faber-medium.onnx.json"
```

### 5.5 Whisper (transcrição de voz)
```bash
pip3 install openai-whisper
python3 -c "import whisper; whisper.load_model('small')"
```
Se pip3 falhar, rode `brew install python` antes e tente novamente.

### 5.6 Bun
```bash
curl -fsSL https://bun.sh/install | bash
export PATH="$HOME/.bun/bin:$PATH"
```

### 5.7 Claude Code
Verifique com `which claude`. Se não estiver instalado:
```bash
npm install -g @anthropic-ai/claude-code
```

### 5.8 Plugin Telegram
```bash
export PATH="$HOME/.bun/bin:$PATH"
claude --dangerously-skip-permissions mcp install @claude-plugins-official/telegram
```

### 5.9 Credenciais do Telegram
Crie os arquivos com o token e o ID fornecidos pelo usuário.

`~/.claude/channels/telegram/.env`:
```
TELEGRAM_BOT_TOKEN=TOKEN_AQUI
```

`~/.claude/channels/telegram/access.json`:
```json
{
  "allowFrom": ["ID_AQUI"]
}
```

```bash
chmod 600 ~/.claude/channels/telegram/.env
chmod 600 ~/.claude/channels/telegram/access.json
mkdir -p ~/.claude/channels/telegram/approved
```

### 5.10 Limpar webhook do bot
```bash
curl -s "https://api.telegram.org/botTOKEN_AQUI/deleteWebhook"
```

### 5.11 Workspace de memória
```bash
mkdir -p ~/.claude/workspace/diario
```

Crie os seguintes arquivos (substituindo NOME_USUARIO pelo nome fornecido):

`~/.claude/workspace/SOUL.md`:
```
# Identidade do Assistente

Você é um assistente pessoal inteligente, ativo 24/7 via Telegram.
Você é direto, prestativo e aprende sobre o usuário ao longo do tempo.
Você fala em português do Brasil.
Você pode executar tarefas no computador do usuário remotamente.
```

`~/.claude/workspace/USER.md`:
```
# Perfil do Usuário

- Nome: NOME_USUARIO
- Sistema: Mac
- Canal: Telegram
```

`~/.claude/workspace/MEMORY.md`:
```
# Memória do Assistente

## Sobre o usuário

## Preferências descobertas

## Projetos em andamento

## Decisões importantes
```

`~/.claude/workspace/NOW.md`:
```
# Foco Atual

(nenhum em andamento)
```

`~/.claude/workspace/HEARTBEAT.md`:
```
# Tarefas do Heartbeat

- [ ] Verificar mensagens pendentes
```

`~/.claude/workspace/BRIEF.md`:
```
(gerado automaticamente)
```

### 5.12 Scripts

`~/.claude/gerar-contexto.sh`:
```bash
#!/bin/bash
WORKSPACE="$HOME/.claude/workspace"
{
  echo "# BRIEF — $(date '+%Y-%m-%d %H:%M')"
  for f in SOUL.md USER.md MEMORY.md NOW.md HEARTBEAT.md; do
    [ -f "$WORKSPACE/$f" ] && cat "$WORKSPACE/$f" && echo ""
  done
  DIARIO="$WORKSPACE/diario/$(date +%Y-%m-%d).md"
  [ -f "$DIARIO" ] && echo "## Diário de Hoje" && cat "$DIARIO"
} > "$WORKSPACE/BRIEF.md"
```

`~/.claude/falar.sh`:
```bash
#!/bin/bash
TEXTO="$1"; CHAT_ID="$2"
TIMESTAMP=$(date +%s%N)
WAV="/tmp/piper-${TIMESTAMP}.wav"
OGG="/tmp/voz-${TIMESTAMP}.ogg"

[ -z "$TEXTO" ] && echo "Uso: falar.sh '<texto>' [chat_id]" >&2 && exit 1

echo "$TEXTO" | /opt/homebrew/bin/piper \
  --model "$HOME/piper-voices/pt_BR-faber-medium.onnx" \
  --output_file "$WAV" 2>/dev/null

ffmpeg -i "$WAV" -c:a libopus -b:a 32k -vbr on "$OGG" -y 2>/dev/null
rm -f "$WAV"

if [ -n "$CHAT_ID" ]; then
  source "$HOME/.claude/channels/telegram/.env" 2>/dev/null
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendVoice" \
    -F "chat_id=${CHAT_ID}" -F "voice=@${OGG}" >/dev/null 2>&1
fi

echo "$OGG"
```

`~/.claude/transcrever-audio.sh`:
```bash
#!/bin/bash
FILE="$1"
[ -z "$FILE" ] || [ ! -f "$FILE" ] && echo "Erro: arquivo não encontrado" >&2 && exit 1

TIMESTAMP=$(date +%s%N)
WAV="/tmp/whisper-${TIMESTAMP}.wav"
OUT="/tmp/whisper-out-${TIMESTAMP}"
mkdir -p "$OUT"

ffmpeg -i "$FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$WAV" -y 2>/dev/null
whisper "$WAV" --model small --language Portuguese --output_format txt --output_dir "$OUT" --verbose False 2>/dev/null

cat "$OUT/$(basename "$WAV" .wav).txt" 2>/dev/null || echo "Erro: transcrição falhou" >&2
rm -f "$WAV"; rm -rf "$OUT"
```

`~/.claude/start-telegram-bot.sh`:
```bash
#!/bin/bash
pkill -f "bun.*server" 2>/dev/null || true
sleep 1
bash "$HOME/.claude/gerar-contexto.sh"
exec /usr/bin/script -q /dev/null claude \
  --dangerously-skip-permissions \
  --channels plugin:telegram@claude-plugins-official
```

`~/.claude/heartbeat-telegram.sh`:
```bash
#!/bin/bash
WORKSPACE="$HOME/.claude/workspace"
MARKER="$WORKSPACE/.ultima-consolidacao"
source "$HOME/.claude/channels/telegram/.env" 2>/dev/null

CHAT_ID=$(python3 -c "
import json
d = json.load(open('$HOME/.claude/channels/telegram/access.json'))
print(d.get('allowFrom',[''])[0])
" 2>/dev/null)

[ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$CHAT_ID" ] && exit 1

bash "$HOME/.claude/gerar-contexto.sh"

HOJE=$(date +%Y-%m-%d)
CONSOLIDAR=false

if [ ! -f "$MARKER" ]; then
  CONSOLIDAR=true
else
  DIAS=$(python3 -c "
from datetime import date
ultima = date.fromisoformat('$(cat "$MARKER")')
print((date.fromisoformat('$HOJE') - ultima).days)
" 2>/dev/null)
  [ "${DIAS:-0}" -ge 3 ] && CONSOLIDAR=true
fi

if [ "$CONSOLIDAR" = true ]; then
  echo "$HOJE" > "$MARKER"
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${CHAT_ID}" \
    --data-urlencode "text=[CONSOLIDAR MEMÓRIA]" >/dev/null 2>&1
fi
# Se não há consolidação, roda silencioso — sem mensagem ao usuário
```

Torne todos executáveis:
```bash
chmod +x ~/.claude/gerar-contexto.sh ~/.claude/falar.sh ~/.claude/transcrever-audio.sh ~/.claude/start-telegram-bot.sh ~/.claude/heartbeat-telegram.sh
```

### 5.13 LaunchAgents (serviços em segundo plano)

Descubra o usuário do Mac com `whoami` e use nos arquivos abaixo no lugar de USUARIO.

`~/Library/LaunchAgents/com.USUARIO.claude-telegram.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.USUARIO.claude-telegram</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USUARIO/.claude/start-telegram-bot.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/Users/USUARIO/.bun/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key><string>/Users/USUARIO</string>
    </dict>
    <key>KeepAlive</key><true/>
    <key>RunAtLoad</key><true/>
    <key>ThrottleInterval</key><integer>30</integer>
    <key>StandardOutPath</key><string>/Users/USUARIO/Library/Logs/claude-telegram.log</string>
    <key>StandardErrorPath</key><string>/Users/USUARIO/Library/Logs/claude-telegram.log</string>
</dict>
</plist>
```

`~/Library/LaunchAgents/com.USUARIO.claude-telegram-heartbeat.plist`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.USUARIO.claude-telegram-heartbeat</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>/Users/USUARIO/.claude/heartbeat-telegram.sh</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/Users/USUARIO/.bun/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
        <key>HOME</key><string>/Users/USUARIO</string>
    </dict>
    <key>StartInterval</key><integer>1800</integer>
    <key>RunAtLoad</key><false/>
    <key>StandardOutPath</key><string>/Users/USUARIO/Library/Logs/claude-telegram-heartbeat.log</string>
    <key>StandardErrorPath</key><string>/Users/USUARIO/Library/Logs/claude-telegram-heartbeat.log</string>
</dict>
</plist>
```

Ative os serviços (substitua USUARIO pelo valor de `whoami`):
```bash
launchctl unload ~/Library/LaunchAgents/com.USUARIO.claude-telegram.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.USUARIO.claude-telegram.plist
launchctl unload ~/Library/LaunchAgents/com.USUARIO.claude-telegram-heartbeat.plist 2>/dev/null || true
launchctl load ~/Library/LaunchAgents/com.USUARIO.claude-telegram-heartbeat.plist
```

### 5.14 Atualizar CLAUDE.md

Verifique se `~/.claude/CLAUDE.md` existe. Adicione no início do arquivo (sem apagar nada):

```
## ASSISTENTE PESSOAL REMOTO

### Ao iniciar uma sessão
Leia `~/.claude/workspace/BRIEF.md` antes de qualquer coisa.

### Ao receber [HEARTBEAT]
1. Leia `~/.claude/workspace/HEARTBEAT.md` e o diário de hoje
2. Execute tarefas pendentes (- [ ]) e marque como feito
3. Se houver algo relevante para o usuário, envie via reply
4. Se não houver nada, não responda

### Ao receber [CONSOLIDAR MEMÓRIA]
1. Leia os diários listados na mensagem
2. Extraia aprendizados duráveis sobre o usuário
3. Acrescente em ~/.claude/workspace/MEMORY.md (nunca apague)
4. Responda apenas: Memória consolidada.

### Mensagens de voz
1. Chame download_attachment com o attachment_file_id
2. Execute bash ~/.claude/transcrever-audio.sh <arquivo>
3. Use o texto transcrito como mensagem

### Quando responder em áudio
- Em áudio: usuário enviou áudio E resposta é conversacional
- Em texto: há código, URLs, listas técnicas ou passos detalhados
- Para gerar: bash ~/.claude/falar.sh "texto" <chat_id>

### Durante as conversas
- Registre no diário: ~/.claude/workspace/diario/YYYY-MM-DD.md
- Atualize NOW.md quando iniciar tarefas longas
```

---

## PASSO 6 — Verificação final

1. Confirme que todos os arquivos foram criados
2. Informe o usuário que pode mandar uma mensagem no Telegram agora
3. Se o bot responder, a instalação foi concluída com sucesso

Finalize com uma mensagem clara informando:
- O @username do bot criado
- Que o assistente está rodando em segundo plano
- Que ele pode usar texto ou voz para se comunicar

Se qualquer passo falhar: explique o erro em linguagem simples, tente corrigir e continue. Não abandone a instalação por causa de um erro sem tentar resolver primeiro.
