{
    const root = typeof globalThis !== "undefined" ? globalThis : self;
    root.bgapp = root.bgapp || {};
    root.browser = root.browser || root.chrome;
}
