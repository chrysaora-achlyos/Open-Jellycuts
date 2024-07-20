window.onload = function() {

  console.log("Hello Mark!")

  // Get references to elements on the page.
  var form = document.getElementById('message-form');
  var messageField = document.getElementById('message');
  var messagesList = document.getElementById('messages');
  var socketStatus = document.getElementById('status');
  var closeBtn = document.getElementById('close');

  // The rest of the code in this tutorial will go here...

  // Create a new WebSocket.
  var socket = new WebSocket('ws://192.168.0.116:80');

  // Show a connected message when the WebSocket is opened.
  socket.onopen = function(event) {
    console.log("ENTER socket.opopen")
    socketStatus.innerHTML = 'Connected to: ' + event.currentTarget.url;
    socketStatus.className = 'open';
    console.log("EXIT socket.onopen")
  };

  // Handle any errors that occur.
  socket.onerror = function(error) {
    console.log('WebSocket Error: ' + error);
  };

  // Show a disconnected message when the WebSocket is closed.
  socket.onclose = function(event) {
    console.log("ENTER socket.onclose")
    socketStatus.innerHTML = 'Disconnected from WebSocket.';
    socketStatus.className = 'closed';
    console.log("EXIT socket.onclose")
  };

  // Close the WebSocket connection when the close button is clicked.
  closeBtn.onclick = function(e) {
    console.log("ENTER closeBtn.onclick")
    e.preventDefault();
    // Close the WebSocket.
    console.log("BEFORE socket.close()")
    socket.close();
    console.log("AFTER socket.close()")
    return true;
  };
};
