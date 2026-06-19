# Changelog

## linux-docker-2.1

Fecha de referencia: 2026-06-19

Estado de la rama:
- Esta rama fue creada desde el commit `df4e14bd30e8975b221f98bf3183a17b3c39497d`.
- Se mantiene como variante Docker/Linux 2.1 centrada en Mason.

Qué incluye:
- Todo lo que ya existía en `df4e14bd30e8975b221f98bf3183a17b3c39497d`.
- `scripts/mason-setup.sh` para instalar herramientas de desarrollo desde Mason en modo headless.
- `scripts/mason.md` con la explicación de uso.
- La corrección del comando de carga de plugins en `mason-setup.sh`.

Qué no incluye:
- No incluye los commits intermedios descartados de `lazygit`, dependencias extra del setup o ajustes ajenos a Mason.
- No redefine la base de `linux-docker-2.0`; solo añade la capa específica de Mason sobre ese punto.
