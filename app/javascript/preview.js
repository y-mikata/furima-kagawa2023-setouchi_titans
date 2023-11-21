const imageUploadPreview = () => {
  // 新規投稿・編集ページのフォームを取得
  const itemForm = document.getElementById("new_item");
  // プレビューを表示するためのスペースを取得
  const previewList = document.getElementById("previews");
  // 新規投稿・編集ページのフォームがないならここで終了。「!」は論理否定演算子。
  if (!itemForm) return null;

  // 投稿できる枚数の制限を定義
  const imageLimits = 5;

  // プレビュー画像を生成・表示する関数
  const buildPreviewImage = (dataIndex, blob) => {
    // 画像を表示するためのdiv要素を生成
    const previewWrapper = document.createElement("div");
    previewWrapper.setAttribute("class", "preview");
    previewWrapper.setAttribute("data-index", dataIndex);

    // 表示する画像を生成
    const previewImage = document.createElement("img");
    previewImage.setAttribute("class", "preview-image");
    previewImage.setAttribute("src", blob);

    // 削除ボタンを生成
    const deleteButton = document.createElement("div");
    deleteButton.setAttribute("class", "image-delete-button");
    deleteButton.innerText = "削除";
    deleteButton.setAttribute("data-index", dataIndex);

    // 削除ボタンをクリックしたらプレビューとifle_fieldを削除させる
    deleteButton.addEventListener("click", () => deleteImage(dataIndex));

    // 生成したHTMLの要素をブラウザに表示させる
    previewWrapper.appendChild(previewImage);
    previewWrapper.appendChild(deleteButton);
    previewList.appendChild(previewWrapper);
  };

  // file_fieldを生成・表示する関数
  const buildNewFileField = () => {
    // 2枚目用のfile_fieldを作成
    const newFileField = document.createElement("input");
    newFileField.setAttribute("type", "file");
    newFileField.setAttribute("name", "item[images][]");

    // 生成したfile_fieldを表示
    const fileFieldsArea = document.querySelector(".click-upload");
    const fileInputsCount = fileFieldsArea.querySelectorAll('input[type="file"]').length;
    // Remove any text nodes that are direct children of the fileFieldsArea.
    Array.from(fileFieldsArea.childNodes).forEach((node) => {
      if (node.nodeType === Node.TEXT_NODE && !/\S/.test(node.nodeValue)) {
        node.remove();
      }
    });
    newFileField.setAttribute("data-index", fileInputsCount);
    newFileField.addEventListener("change", changedFileField);
    fileFieldsArea.appendChild(newFileField);
  };

  // 指定したdata-indexを持つプレビューとfile_fieldを削除する
  const deleteImage = (dataIndex) => {
    // Delete the preview
    const deletePreviewImage = document.querySelector(`.preview[data-index="${dataIndex}"]`);
    if (deletePreviewImage) {
      deletePreviewImage.remove();
    }

    // Delete the file field and clear its value
    const deleteFileField = document.querySelector(`input[type="file"][data-index="${dataIndex}"]`);
    if (deleteFileField) {
      deleteFileField.remove();
    }

    // Update the indexes of remaining file fields
    updateIndexes();

    // Remove the last file field if it's empty
    const fileFieldsArea = document.querySelector(".click-upload");
    const lastFileField = fileFieldsArea.querySelector('input[type="file"]:last-child');
    if (lastFileField && lastFileField.files.length === 0) {
      lastFileField.remove();
    }

    // Check if a new file field should be added
    const imageCount = document.querySelectorAll(".preview").length;
    const fileInputCount = fileFieldsArea.querySelectorAll('input[type="file"]').length;
    if (imageCount < imageLimits && fileInputCount < imageLimits) {
      buildNewFileField();
    }
  };

  const updateIndexes = () => {
    const fileFields = document.querySelectorAll('input[type="file"][name="item[images][]"]');
    fileFields.forEach((field, index) => {
      field.setAttribute("data-index", index);
    });

    const previews = document.querySelectorAll(".preview");
    previews.forEach((preview, index) => {
      preview.setAttribute("data-index", index);
      const oldDeleteButton = preview.querySelector(".image-delete-button");
      const newDeleteButton = oldDeleteButton.cloneNode(true);
      oldDeleteButton.parentNode.replaceChild(newDeleteButton, oldDeleteButton);
      newDeleteButton.addEventListener("click", () => deleteImage(index));
    });
  };

  // input要素で値の変化が起きた際に呼び出される関数の中身
  const changedFileField = (e) => {
    // data-index（何番目を操作しているか）を取得
    const dataIndex = e.target.getAttribute("data-index");

    const file = e.target.files[0];

    // fileが空 = 何も選択肢なかったのでプレビューらを削除して終了する
    if (!file) {
      deleteImage(dataIndex);
      return null;
    }

    const blob = window.URL.createObjectURL(file);

    // data-indexを使用して、すでにプレビューが表示されているかを確認する
    const alreadyPreview = document.querySelector(`.preview[data-index="${dataIndex}"]`);

    if (alreadyPreview) {
      // クリックしたfile_fieldのdata-indexと、同じ番号のプレビュー画像がすでに表示されている場合は、画像の差し替えのみを行う
      const alreadyPreviewImage = alreadyPreview.querySelector("img");
      alreadyPreviewImage.setAttribute("src", blob);
      return null;
    }

    buildPreviewImage(dataIndex, blob);

    // 画像の枚数制限に引っ掛からなければ、新しいfile_fieldを追加する
    const imageCount = document.querySelectorAll(".preview").length;
    if (imageCount < imageLimits) buildNewFileField();
  };

  // input要素を取得
  const fileField = document.querySelector('input[type="file"][name="item[images][]"');

  // input要素で値の変化が起きた際に呼び出される関数
  fileField.addEventListener("change", changedFileField);
};

document.addEventListener("turbo:load", imageUploadPreview);
document.addEventListener("turbo:render", imageUploadPreview);
