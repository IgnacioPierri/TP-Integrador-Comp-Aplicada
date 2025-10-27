# TP Integrador - Computación Aplicada
Entrega final del TP Integrador de Computación Aplicada - Debian, Apache, MariaDB, SSH, Backups.

## Integrantes
- Franco Castillo  
- Ignacio Pierri  
- Maia Catalina Gallardo Mangiamarchi  
- Nicolas Esteban Abraham  
- Yanel Ricarte  

## Infraestructura
- **Sistema operativo**: Debian (VM en VirtualBox)  
- **Hostname**: TPServer  
- **Servicios instalados**:  
  - SSH (root con clave pública/privada)  
  - Apache2 + PHP (sirviendo index.php y logo.png desde /www_dir)  
  - MariaDB (base de datos `ingenieria`, con tablas `alumnos`, `modulos`, `notas`)  

## Red
- Configuración con IP estática en la VM.  
- Conectividad validada vía SSH y HTTP desde el host.  

## Almacenamiento
- Disco adicional de 10 GB → dividido en:  
  - **/dev/sdb1** (3 GB) montado en `/www_dir`  
  - **/dev/sdb2** (6 GB) montado en `/backup_dir`  
- Archivo `/opt/particion` con contenido de `/proc/partitions`.  

## Backups
- Script: `/opt/scripts/backup_full.sh`  
- Funcionalidades:  
  - Acepta parámetros `<origen> <destino>` y opción `-help`  
  - Valida montajes antes de ejecutar  
  - Genera archivos `.tar.gz` con fecha (`YYYYMMDD`)  
- Ejemplos de uso:  
  - `/opt/scripts/backup_full.sh /www_dir /backup_dir --tag www`  
  - `/opt/scripts/backup_full.sh /var/log /backup_dir --tag logs`  
- Automatización con `cron`:  
  - Todos los días a las 00:00 → backup de `/var/log`  
  - Lunes, Miércoles y Viernes a las 23:00 → backup de `/www_dir`  

## Entregables
- Archivos comprimidos en `.tar.gz`:  
  - `root.tgz`  
  - `etc.tgz`  
  - `opt.tgz`  
  - `www_dir.tgz`  
  - `backup_dir.tgz`  

## Restauración
- Restaurar un directorio:  
  ```bash
  tar -xzf archivo.tgz -C /

