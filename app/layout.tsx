import type { Metadata } from "next";
import "./globals.css";
import { withBasePath } from "./site-path";

export const metadata: Metadata = {
  title: "Jérôme Desale | e-Healthcare & Data Science",
  description: "Portfolio of Jérôme Desale, final-year engineering student working across e-Health, biomechanics, data engineering and artificial intelligence.",
  icons: { icon: withBasePath("/favicon.svg"), shortcut: withBasePath("/favicon.svg") },
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return <html lang="en"><body>{children}</body></html>;
}
