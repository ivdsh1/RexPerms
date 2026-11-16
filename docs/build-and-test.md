# Clonar, compilar e testar

Use um **JDK completo** (8, 17 ou 21) e Maven 3.8+ no PATH. O compiler plugin 3.13 gera bytecode Java 8 com `release=8`. Um JRE reduzido sem `ct.sym` não basta para essa configuração. Confira `java -version` e `mvn -version`; o JAVA_HOME deve apontar para o JDK.

Os dois diretórios devem ser irmãos:

```sh
git clone --branch feature/rexperms-guard-bundle https://github.com/ivdsh1/RexPerms.git
git clone --branch feature/rexperms-guard-bundle https://github.com/ivdsh1/RexPermsGuard.git
cd RexPerms
```

O Guard está em um repositório privado; use a autenticação normal do GitHub para clonar. Não cole tokens em logs ou comandos compartilhados.

Linux/macOS:

```sh
sh build-all.sh
```

Windows (Prompt ou PowerShell):

```bat
build-all.bat
```

Ambos executam o reactor Maven `mvn -B -f bundle/pom.xml clean verify`, com testes habilitados. Também é possível iniciar pelo `build.sh`/`build.bat` do Guard.

Para compilar separadamente, na raiz do RexPerms rode `mvn clean install`, depois na raiz do Guard rode `mvn clean verify`. O Guard exige o artefato modificado `2.0.0-guard.1-SNAPSHOT`; o JAR 2.0.0 original não serve.

## JARs

- `RexPerms/target/RexPerms-2.0.0-guard.1-SNAPSHOT.jar`
- `RexPermsGuard/target/RexPermsGuard-0.1.0-SNAPSHOT.jar`

Copie esses dois para `plugins/` de um servidor de teste 1.8.8. Não use o arquivo `original-RexPerms-...jar` criado pelo Shade. Não deixe versões antigas duplicadas na pasta.

## Configuração inicial

O Guard gera `plugins/RexPermsGuard/config.yml`. Os cargos precisam existir no RexPerms e também estar em `roles` do Guard. Os pesos administrativos do Guard são independentes dos pesos de exibição do RexPerms. Grupos desconhecidos bloqueiam a decisão. Mantenha `default` configurado.

No console, crie os cargos necessários, por exemplo `rp creategroup diretor`, e conceda a permissão `rp group diretor permission set rexpermsguard.manage true` aos cargos que administram. A permissão apenas habilita o uso: OP, `*` e `rexpermsguard.manage` continuam sujeitos à hierarquia e à lista de operações. Atribua o primeiro dono pelo console.

Use `/rpg add <jogador-online> <grupo>` e `/rpg remove <jogador-online> <grupo>`, ou os comandos normais do RexPerms com permissões apropriadas. Os dois caminhos passam pela política no momento da mutação. O `/rpg` é uma interface simples para alvos online; os comandos `/rp user` e a API também atendem usuários offline.

Mudanças de configuração devem ser seguidas de reinício controlado. Não use ferramentas de hot-reload/PlugMan; desativar uma política obrigatória faz o núcleo rejeitar mutações.

## Matriz de validação no servidor

Faça backup antes dos testes. Teste com jogadores distintos, com e sem OP e com `*`:

1. Console atribui/remove dono; todos os jogadores são impedidos de fazer isso.
2. Diretor gerencia admin e inferiores; admin gerencia moderador e inferiores; moderador não atribui/remove nenhum grupo.
3. Autoalteração e alvos de cargo igual/superior são rejeitados, inclusive com múltiplos cargos, contexto diferente e herança transitiva.
4. Compare dados e arquivos antes/depois de cancelar um evento. Nenhuma gravação, anúncio de sucesso ou evento posterior deve aparecer.
5. Tente permissão `*`, remoção de permissão negativa, prefixo/meta, grupo principal, tracks, clone, rename e lotes mistos. Jogadores não podem editar definições estruturais; um item rejeitado deve cancelar o lote inteiro.
6. Faça uma alteração Vault sem autor: o Guard deve negar. Uma loja não pode comprar cargos por Vault sem uma integração explicitamente atribuída.
7. Teste importação por console com um listener que cancela um alvo; reinicie e confirme que não houve persistência. Repita com usuários offline.
8. Teste expiração, login/logout, falha de armazenamento e reinício. Sincronização remota é recusada pelo Guard porque não traz autor verificável.

## Logs para diagnóstico

Linux:

```sh
sh build-all.sh > build.log 2>&1
```

PowerShell:

```powershell
.\build-all.bat *> build.log
```

Envie `build.log`, saída de `mvn -version`, hashes de `git rev-parse HEAD` nos dois repositórios e a primeira seção `[ERROR]` com o `Caused by` completo. Para falha de teste, inclua `target/surefire-reports/*.txt`. Para falha no servidor, inclua o trecho de `logs/latest.log` desde a ativação dos dois plugins até o erro, a versão exata do servidor/Java e os passos para reproduzir. Remova senhas, tokens, IPs privados e credenciais SQL.

Não desative os testes para contornar falhas. Erros 401/403 de dependências precisam ser separados de erros de compilação; o POM inclui o repositório oficial do Spigot e o espelho oficial do Paper para artefatos históricos.
