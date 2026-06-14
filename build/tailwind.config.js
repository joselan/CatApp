/** Config de Tailwind para compilar el CSS de CatApp (reemplaza el CDN).
 *  Para regenerar el CSS:  npx tailwindcss@3 -c build/tailwind.config.js -i build/input.css -o catapp.css --minify
 */
module.exports = {
  content: ['./index.html'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'sans-serif'],
        serif: ['Playfair Display', 'serif'],
        cursive: ['Alex Brush', 'cursive'],
      },
      colors: {
        darkbg: '#000000',
        glass: 'rgba(12, 12, 16, 0.76)',
        silverGlow: '#E2E8F0',
        fiesta: '#ec4899',
        fiestaDark: '#be185d',
        fiestaViolet: '#8b5cf6',
      },
    },
  },
  plugins: [],
};
