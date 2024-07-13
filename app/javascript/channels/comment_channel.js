import consumer from "channels/consumer";

if (location.pathname.match(/\/items\/\d/)) {
  consumer.subscriptions.create(
    {
      channel: "CommentChannel",
      item_id: location.pathname.match(/\d+/)[0],
    },
    {
      connected() {
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        const html = `
      <div class="flex gap-1">
        <p class="m-0 font-bold text-gray-500">${data.user.nickname}: </p>
        <p class="m-0">${data.comment.text}</p>
      </div>`;
        const comments = document.getElementById("comments");
        comments.insertAdjacentHTML("beforeend", html);
        const commentForm = document.getElementById("comment-form");
        commentForm.reset();
      },
    }
  );
}
