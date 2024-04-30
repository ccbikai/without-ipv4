const DIP_NAME = "DIP_INFO_";

export default async function eventHandler(event) {
	const kv = useStorage("vercelKV");
	const body = await readBody(event);
	const ip = body.ip || "";
	const port = body.port || "";
	const key = body.key || "0";
	console.info("DIP set", { ip, port });
	await kv.setItem(DIP_NAME + key, { ip, port });
	return {
		success: true,
	};
}
