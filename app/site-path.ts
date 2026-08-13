export const GITHUB_PAGES_BASE_PATH = "/jerome-portfolio";

export function withBasePath(path: string) {
  if (path.startsWith("#") || path.startsWith("http") || path.startsWith("mailto:")) {
    return path;
  }

  const normalisedPath = path.startsWith("/") ? path : `/${path}`;
  return `${GITHUB_PAGES_BASE_PATH}${normalisedPath}`;
}
