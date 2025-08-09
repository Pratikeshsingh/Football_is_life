import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import nodemailer from "npm:nodemailer";

serve(async (req: Request) => {
  try {
    const { to, subject, body } = await req.json();

    const transporter = nodemailer.createTransport({
      host: Deno.env.get("SMTP_HOST"),
      port: Number(Deno.env.get("SMTP_PORT")),
      auth: {
        user: Deno.env.get("SMTP_USERNAME"),
        pass: Deno.env.get("SMTP_PASSWORD"),
      },
    });

    await transporter.sendMail({
      from: Deno.env.get("SMTP_USERNAME"),
      to,
      subject,
      html: body,
    });

    return new Response(
      JSON.stringify({ message: "Email sent" }),
      { headers: { "Content-Type": "application/json" }, status: 200 },
    );
  } catch (error) {
    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { headers: { "Content-Type": "application/json" }, status: 500 },
    );
  }
});
