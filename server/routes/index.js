export default eventHandler((event) => {
	return sendRedirect(event, "https://github.com/ccbikai/without-ipv4", 302);
});
