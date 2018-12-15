// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require jquery
//= require turbolinks
//= require_tree .

// $(function() {
// 	$(document).on('ajax:success', 'form', function(e) {
//     $('#year').val('');
//     $('.film_list').prepend('<p>' + e.detail[0] + '</p>');
//   })
  
//   $(document).on('click', 'input[type=submit]', function() {
//     if ($('input[type=text]').val() == '') {
//       return false;
//     }
//   })
// })



$(function(){
  $("#submit_button").click(function(){ //送信ボタンを押すとイベントが発火します
    var input = $("#search_form").val(); // フォームの値を'input'という名前の変数に代入します
    $.ajax({
      type:'GET', // リクエストのタイプはGETです
      url: '/search', // URLは"/meals"を指定します
      data: {keyword: input}, // コントローラへフォームの値を送信します
      dataType: 'json' // データの型はjsonで指定します
    })
    .done(function(data){
      // 通信に成功した場合の処理です
      $('.film_list').empty(); //前回の検索結果が残っている場合はそれを消します
      $('.film_list').prepend('<p>' + e.detail[0] + '</p>');//film_listクラスの先頭に投稿した文字列を表示します。
    })
    .fail(function(){
      // 通信に失敗した場合の処理です
      alert('検索に失敗しました') // alertで検索失敗の旨を表示します
    })
  })
})
$(function(){
  $("#submit_button").click(function(){ //送信ボタンを押すとイベントが発火します
    var input = $("#trends_form").val(); // フォームの値を'input'という名前の変数に代入します
    $.ajax({
      type:'GET', // リクエストのタイプはGETです
      url: '/trends', // URLは"/meals"を指定します
      data: {keyword: input}, // コントローラへフォームの値を送信します
      dataType: 'json' // データの型はjsonで指定します
    })
    .done(function(data){
      // 通信に成功した場合の処理です
      $('.trends_list').empty(); //前回の検索結果が残っている場合はそれを消します
      $('.trends_list').prepend('<p>' + e.detail[0] + '</p>');//film_listクラスの先頭に投稿した文字列を表示します。
    })
    .fail(function(){
      // 通信に失敗した場合の処理です
      alert('検索に失敗しました') // alertで検索失敗の旨を表示します
    })
  })
})
$(function(){
  $("#submit_button").click(function(){ //送信ボタンを押すとイベントが発火します
    var input = $("#lists_form").val(); // フォームの値を'input'という名前の変数に代入します
    $.ajax({
      type:'GET', // リクエストのタイプはGETです
      url: '/lists', // URLは"/lists"を指定します
      data: {keyword: input}, // コントローラへフォームの値を送信します
      dataType: 'json' // データの型はjsonで指定します
    })
    .done(function(data){
      // 通信に成功した場合の処理です
      $('.favorite_list').empty(); //前回の検索結果が残っている場合はそれを消します
      $('.favorite_list').prepend('<p>' + e.detail[0] + '</p>');//film_listクラスの先頭に投稿した文字列を表示します。
    })
    .fail(function(){
      // 通信に失敗した場合の処理です
      alert('検索に失敗しました') // alertで検索失敗の旨を表示します
    })
  })
})
