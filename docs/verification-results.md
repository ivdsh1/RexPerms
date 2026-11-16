# Verification on 2026-11-16

## Executed

- Compared upstream and fork main, previous feature branch and both attached archives.
- Applied the 24-path patch to original main in a separate worktree and compared its corresponding files with the full archive: matching contents.
- Compiled both complete source projects against Spigot API 1.8.8 in one Maven reactor and produced both JARs.
- RexPerms: **36 tests, 0 failures, 0 errors, 0 skipped**.
- RexPermsGuard: **11 tests, 0 failures, 0 errors, 0 skipped**.
- Inspected project class-file headers: all **117 core classes** and **4 Guard classes** use major version **52** (Java 8).
- Checked the source diff for whitespace errors and excluded all ZIPs, JARs, target directories, logs, temporary verification POMs and downloaded tools from publication.

The tests cover original calculator/storage behavior, event immutability/cancellation, compound rollback, direct managed mutators, registry/track rollback, reentrant authorization, draft isolation from other threads, nested failures and exceptional completion of canceled effects. Guard tests cover the initial hierarchy, self/equal/higher targets, contextual and inherited ranks, expired actor ranks, missing/unknown groups, permission and metadata escalation, negated inheritance, owner/primary group changes, mixed batches and inheritance cycles.

## Environment distinction

The runtime is OpenJDK **21.0.13** with a reduced JDK/JRE image missing `ct.sym` and the `javac` launcher. The unchanged normal `release=8` configuration was attempted and failed because that image cannot resolve a release platform. For actual verification, temporary POMs replaced `release=8` with `source=8` and `target=8`; the compiler module successfully compiled the real source and the class headers were checked afterwards. These temporary POMs are **not published**. Therefore:

- Compilation, Maven reactor ordering, unit tests, packaging and Java-8 bytecode were verified.
- Java-8 standard-library linkage and execution on a real Java-8 VM were **not** verified here.
- The published POMs retain `release=8` and should be compiled with a complete JDK locally.

The historical Spigot repository returned HTTP 403 through this environment. Its official Paper mirror supplied the same Spigot snapshot. Maven was run with a temporary environment proxy configuration; no proxy settings, credentials or verification binaries are included in either repository.

## Not executed

A real Bukkit/Spigot 1.8.8 server was not started. Login/logout races, OP and wildcard behavior in the live command dispatcher, real Vault consumers, remote database writers, crashes and disk failure during an accepted batch still require the server validation matrix in [build-and-test.md](build-and-test.md).

Do not infer production readiness from these results. See the exact trust boundary and persistence limitations in [mutation-authorization-status.md](mutation-authorization-status.md).
