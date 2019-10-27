export class InterviewClient {
  search(callback) {
    $.ajax({
      url: '/candidates',
      method: 'GET',
      headers: { 'Content-Type': 'application/json' },
      dateType: 'json',
      success: (res) => {
        callback(res);
      }
    });
  }
}