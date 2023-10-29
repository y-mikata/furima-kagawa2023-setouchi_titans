document.addEventListener('turbo:load', function(){
  const itemForm = document.getElementById('new_item');
  const previewList = document.getElementById('previews');
  
  if (!itemForm) return null;
  console.log("preview.jsが読み込まれました");

  const fileField = document.querySelector('input[type="file"][name="item[image]"');
  fileField.addEventListener('change', function(e){
    console.log("input要素で値の変化が起きました");
    console.log(e.target.files[0]);
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    console.log(blob);
  });
});