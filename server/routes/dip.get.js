const DIP_NAME = "DIP_INFO_";

export default async function eventHandler(event) {
	const kv = useStorage("vercelKV");
	const query = getQuery(event);
	const key = query.key || "0";
	const { ip = "0.0.0.0", port = 0 } = (await kv.getItem(DIP_NAME + key)) || {};
	const password = query.password || "password";
	console.info("DIP get", { ip, port });
	return `
proxies:
  - name: OMV-${key}
    type: ss
    server: ${ip}
    port: ${port}
    cipher: aes-128-gcm
    password: ${password}
`;
}
