const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/views/**/*.{erb,haml,html,slim}",
  ],
  theme: {
    extend: {
      colors: {
        furimaTeal: "#3ccace",
      },
      spacing: {
        "sp-3xs": ["clamp(0.25rem, 0.2216rem + 0.1136vi, 0.3125rem)"],
        "sp-2xs": ["clamp(0.5rem, 0.4432rem + 0.2273vi, 0.625rem)"],
        "sp-xs": ["clamp(0.75rem, 0.6932rem + 0.2273vi, 0.875rem)"],
        "sp-s": ["clamp(1rem, 0.9148rem + 0.3409vi, 1.1875rem)"],
        "sp-m": ["clamp(1.5rem, 1.358rem + 0.5682vi, 1.8125rem)"],
        "sp-l": ["clamp(2rem, 1.8295rem + 0.6818vi, 2.375rem)"],
        "sp-xl": ["clamp(3rem, 2.7443rem + 1.0227vi, 3.5625rem)"],
        "sp-2xl": ["clamp(4rem, 3.6591rem + 1.3636vi, 4.75rem)"],
        "sp-3xl": ["clamp(6rem, 5.4886rem + 2.0455vi, 7.125rem)"],
        "sp-5xl": ["clamp(12rem, 10.9773rem + 4.0909vi, 14.25rem)"],
        "sp-6xl": ["clamp(15rem, 13.7216rem + 5.1136vi, 17.8125rem)"],

        /* One-up pairs */
        "sp-3xs-2xs": ["clamp(0.25rem, 0.0795rem + 0.6818vi, 0.625rem)"],
        "sp-2xs-xs": ["clamp(0.5rem, 0.3295rem + 0.6818vi, 0.875rem)"],
        "sp-xs-s": ["clamp(0.75rem, 0.5511rem + 0.7955vi, 1.1875rem)"],
        "sp-s-m": ["clamp(1rem, 0.6307rem + 1.4773vi, 1.8125rem)"],
        "sp-m-l": ["clamp(1.5rem, 1.1023rem + 1.5909vi, 2.375rem)"],
        "sp-l-xl": ["clamp(2rem, 1.2898rem + 2.8409vi, 3.5625rem)"],
        "sp-xl-2xl": ["clamp(3rem, 2.2045rem + 3.1818vi, 4.75rem)"],
        "sp-2xl-3xl": ["clamp(4rem, 2.5795rem + 5.6818vi, 7.125rem)"],
        "sp-4xl-5xl": ["clamp(8rem, 5.1591rem + 11.3636vi, 14.25rem)"],
        "sp-5xl-6xl": ["clamp(12rem, 9.358rem + 10.5682vi, 17.8125rem)"],

        /* Custom pairs */
        "sp-s-l": ["clamp(1rem, 0.375rem + 2.5vi, 2.375rem)"],
        "sp-3xs-5xl": ["clamp(0.25rem, -6.1136rem + 25.4545vi, 14.25rem)"],
        "sp-3xl-5xl": ["clamp(6rem, 2.25rem + 15vi, 14.25rem)"],
        "sp-3xl-6xl": ["clamp(8rem, 0.6307rem + 21.4773vi, 17.8125rem)"],
        "sp-4xl-6xl": ["clamp(8rem, 3.5398rem + 17.8409vi, 17.8125rem)"],
      },
      fontSize: {
        "fs-xs": ["clamp(0.64rem, 0.05vi + 0.63rem, 0.67rem)"],
        "fs-sm": ["clamp(0.8rem, 0.17vi + 0.76rem, 0.89rem)"],
        "fs-base": ["clamp(1rem, 0.34vi + 0.91rem, 1.19rem)"],
        "fs-md": ["clamp(1.25rem, 0.61vi + 1.1rem, 1.58rem)"],
        "fs-lg": ["clamp(1.56rem, 1vi + 1.31rem, 2.11rem)"],
        "fs-xl": ["clamp(1.95rem, 1.56vi + 1.56rem, 2.81rem)"],
        "fs-xxl": ["clamp(2.44rem, 2.38vi + 1.85rem, 3.75rem)"],
        "fs-xxxl": ["clamp(3.05rem, 3.54vi + 2.17rem, 5rem)"],
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/container-queries"),
  ],
};
