# Mesas — cómo funciona y cómo compartirlas entre los 4 admins

## Qué es

En el **Ranking** (lo ven solo los admins) hay un botón nuevo: **🍽️ Mesas**.
Ahí podés armar la distribución de la fiesta:

- **➕ Agregar mesa**: crea una mesa nueva (Mesa 1, Mesa 2, …).
- Tocá el **nombre** de una mesa (con el ✏️) para cambiarlo
  (ej. "Familia", "Amigos de Cata", "Colegio").
- Tocá el número **0/10** para cambiar cuántas personas entran.
- Con el desplegable **"➕ Sentar invitado…"** elegís a quién sentar.
  El número al lado de cada nombre es cuánta gente trae esa invitación.
- La **×** al lado de cada invitado lo saca de la mesa.
- Abajo de todo, **"Sin mesa asignada"** te muestra a quién te falta sentar.
- Arriba ves el resumen: **Mesas · Sentados · Sin mesa**.

Solo los admins (José, Cata, Seba y Mari) ven y editan las mesas.

## ¿Se comparte entre los 4 admins?

- **Por defecto** las mesas se guardan en **tu teléfono**. Funcionan perfecto,
  pero cada admin ve su propia distribución.
- Para que los 4 vean y editen **la misma** distribución en vivo, hay que
  crear una tabla en la base compartida (Supabase). Es un paso de 1 minuto.

## Cómo activar las mesas compartidas (opcional, 1 minuto)

1. Entrá a tu proyecto en **https://supabase.com** → menú **SQL Editor**.
2. Tocá **New query**.
3. Abrí el archivo `supabase/mesas.sql` de este proyecto, copiá **todo** y
   pegalo en el editor.
4. Tocá **Run** (abajo a la derecha).
5. Listo. Desde ese momento, cuando un admin arme las mesas, las van a ver
   los 4 al instante.

> Se puede ejecutar más de una vez sin problema. No borra nada de lo que ya
> tenías (canciones, votos, invitados).
