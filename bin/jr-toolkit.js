#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const CLAUDE_SKILLS_DIR = path.join(os.homedir(), '.claude', 'skills');
const CLAUDE_COMMANDS_DIR = path.join(os.homedir(), '.claude', 'commands');
const SKILLS_SRC = path.join(__dirname, '..', 'skills');

const SKILLS = [
  'jr-init',
  'jr-vision',
  'jr-arch',
  'jr-roadmap',
  'jr-build-spec',
  'jr-iterate-spec',
  'jr-exe-spec',
  'jr-verify-spec',
  'jr-fix-spec',
  'jr-status',
];

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  blue: '\x1b[34m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  bold: '\x1b[1m',
};

const c = (color, text) => `${colors[color]}${text}${colors.reset}`;

function copyDirSync(src, dest) {
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) copyDirSync(srcPath, destPath);
    else fs.copyFileSync(srcPath, destPath);
  }
}

function install() {
  console.log('');
  console.log(c('bold', '╔══════════════════════════════════════════════════════╗'));
  console.log(c('bold', '║         jr-toolkit — Spec-Driven Development         ║'));
  console.log(c('bold', '╚══════════════════════════════════════════════════════╝'));
  console.log('');

  // Create base dirs
  fs.mkdirSync(CLAUDE_SKILLS_DIR, { recursive: true });
  fs.mkdirSync(CLAUDE_COMMANDS_DIR, { recursive: true });

  let errors = 0;

  for (const skill of SKILLS) {
    const srcSkill = path.join(SKILLS_SRC, skill);
    const destSkill = path.join(CLAUDE_SKILLS_DIR, skill);
    const srcCommand = path.join(srcSkill, 'command.md');
    const destCommand = path.join(CLAUDE_COMMANDS_DIR, `${skill}.md`);

    if (!fs.existsSync(srcSkill)) {
      console.log(c('yellow', `⚠  ${skill} — no encontrado en el paquete, saltando`));
      errors++;
      continue;
    }

    // Remove and reinstall skill
    if (fs.existsSync(destSkill)) fs.rmSync(destSkill, { recursive: true });
    copyDirSync(srcSkill, destSkill);

    // Install command
    if (fs.existsSync(srcCommand)) {
      fs.copyFileSync(srcCommand, destCommand);
    }

    console.log(c('green', `✓`) + ` ${skill}`);
  }

  console.log('');

  if (errors === 0) {
    console.log(c('green', c('bold', '✅ Toolkit instalado correctamente')));
    console.log('');
    console.log('  ' + c('bold', 'Comandos disponibles en Claude.ai:'));
    console.log('  ' + c('blue', '/jr-init') + '             → Inicializar proyecto (PROJECT.md)');
    console.log('  ' + c('blue', '/jr-vision') + '           → Idea → Documento de visión del producto');
    console.log('  ' + c('blue', '/jr-arch') + '             → Visión → Arquitectura técnica del sistema');
    console.log('  ' + c('blue', '/jr-roadmap') + '          → Arquitectura → Roadmap y backlog ordenado');
    console.log('  ' + c('blue', '/jr-build-spec') + '        → Requerimiento → Spec Draft');
    console.log('  ' + c('blue', '/jr-iterate-spec') + '      → Iterar un spec existente');
    console.log('  ' + c('blue', '/jr-exe-spec') + '          → Implementar un spec');
    console.log('  ' + c('blue', '/jr-verify-spec') + '       → Verificar cobertura de CAs');
    console.log('  ' + c('blue', '/jr-fix-spec') + '          → Diagnosticar y corregir bugs');
    console.log('  ' + c('blue', '/jr-status') + '            → Dashboard de specs');
    console.log('');
    console.log('  ' + c('yellow', 'Reinicia Claude.ai para activar los skills.'));
    console.log('');
  } else {
    console.log(c('red', `⚠ Instalación con ${errors} problema(s).`));
    process.exit(1);
  }
}

function uninstall() {
  console.log('');
  console.log(c('bold', 'Desinstalando jr-toolkit...'));
  console.log('');

  for (const skill of SKILLS) {
    const destSkill = path.join(CLAUDE_SKILLS_DIR, skill);
    const destCommand = path.join(CLAUDE_COMMANDS_DIR, `${skill}.md`);

    if (fs.existsSync(destSkill)) {
      fs.rmSync(destSkill, { recursive: true });
      console.log(c('green', '✓') + ` ${skill} eliminado`);
    }
    if (fs.existsSync(destCommand)) {
      fs.unlinkSync(destCommand);
    }
  }

  console.log('');
  console.log(c('green', '✅ jr-toolkit desinstalado'));
  console.log('');
}

function listSkills() {
  console.log('');
  console.log(c('bold', 'jr-toolkit — Skills instalados:\n'));

  for (const skill of SKILLS) {
    const installed = fs.existsSync(path.join(CLAUDE_SKILLS_DIR, skill));
    const status = installed ? c('green', '✓ instalado') : c('yellow', '✗ no instalado');
    console.log(`  /${skill}  ${status}`);
  }
  console.log('');
}

function showHelp() {
  console.log('');
  console.log(c('bold', 'jr-toolkit') + ' — Spec-Driven Development para Claude.ai');
  console.log('');
  console.log(c('bold', 'Uso:'));
  console.log('  npx jr-toolkit install     Instala todos los skills en ~/.claude/');
  console.log('  npx jr-toolkit uninstall   Desinstala todos los skills');
  console.log('  npx jr-toolkit list        Lista los skills y su estado');
  console.log('  npx jr-toolkit help        Muestra esta ayuda');
  console.log('');
  console.log(c('bold', 'Skills incluidos:'));
  console.log('  /jr-init           Inicializar proyecto (PROJECT.md)');
  console.log('  /jr-vision         Idea → Documento de visión del producto');
  console.log('  /jr-arch           Visión → Arquitectura técnica del sistema');
  console.log('  /jr-roadmap        Arquitectura → Roadmap y backlog ordenado');
  console.log('  /jr-build-spec     Requerimiento crudo → Spec Draft');
  console.log('  /jr-iterate-spec   Iterar un spec existente');
  console.log('  /jr-exe-spec       Implementar un spec en código');
  console.log('  /jr-verify-spec    Verificar cobertura de criterios de aceptación');
  console.log('  /jr-fix-spec       Diagnosticar y corregir bugs');
  console.log('  /jr-status         Dashboard del estado de specs del proyecto');
  console.log('');
  console.log(c('bold', 'Más info:') + ' https://github.com/YOUR_USERNAME/jr-toolkit');
  console.log('');
}

// CLI router
const command = process.argv[2];

switch (command) {
  case 'install':   install();    break;
  case 'uninstall': uninstall();  break;
  case 'list':      listSkills(); break;
  case 'help':
  case '--help':
  case '-h':        showHelp();   break;
  default:
    if (!command) {
      install(); // default: install
    } else {
      console.log(c('red', `Comando desconocido: ${command}`));
      showHelp();
      process.exit(1);
    }
}
