import { onDocumentCreated } from "firebase-functions/v2/firestore";
import * as https from "https";
import { Contact } from "../models/contact";

export const notifyContact = onDocumentCreated(
  {
    document: "contacts/{contactId}",
    secrets: ["LINE_CHANNEL_ACCESS_TOKEN"],
    region: "asia-northeast1",
  },
  async (event) => {
    const data = event.data?.data();
    if (!data) return;
    const contact: Contact = new Contact(data);

    const userId = "U4a98564f54715db1129d0db57e423878";
    const post = {
      "to": userId,
      "messages": [
        {
          "type": "text",
          "text": `お問い合わせ\n\n名前:\n${contact.name}\n\nメールアドレス:\n${contact.email}\n\n件名:\n${contact.getSubject()}\n\n内容:\n${contact.content}`,
        },
      ],
    };
    const postData = JSON.stringify(post);

    const url = "https://api.line.me/v2/bot/message/push";
    const options: https.RequestOptions = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${process.env.LINE_CHANNEL_ACCESS_TOKEN}`,
      },
    };
    const req = https.request(url, options, (res) => res.setEncoding("utf8"));
    req.write(postData);
    req.end();
  }
);
