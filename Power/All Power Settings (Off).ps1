## Run as: SYSTEM
## Max Script Time: 2 Minutes
## Turns off disk sleep, PC sleep and hibernate.

powercfg /change monitor-timeout-ac 60
powercfg /change monitor-timeout-dc 10

powercfg /change disk-timeout-ac 0
powercfg /change disk-timeout-dc 0

powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

powercfg /change hibernate-timeout-ac 0
powercfg /change hibernate-timeout-dc 0
