document.addEventListener('turbo:load', function(){
  const itemForm = document.getElementById('new_item');
  const previewList = document.getElementById('previews');
  
  if (!itemForm) return null;

  const fileField = document.querySelector('input[type="file"][name="item[image]"');
  fileField.addEventListener('change', function(e){
    const file = e.target.files[0];
    const blob = window.URL.createObjectURL(file);
    
    const previewWrapper = document.createElement('div');
    previewWrapper.setAttribute('class', 'preview');

    const previewImage = document.createElement('img');
    previewImage.setAttribute('class', 'preview-image');
    previewImage.setAttribute('src', blob);
  });
});