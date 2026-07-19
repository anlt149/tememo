---
title: "Go Pointer"
description: "Pointer"
pubDate: "Jul 19 2026"
tags: ["go", "languague", "learn"]
---

Là một kỹ sư mất gốc - thỉnh thoảng tôi vẫn hay nhầm lẫn giữa các khái niệm cụ thể là con trỏ.


Là một Java engineer - thực chất tôi đã sử dụng con trỏ mỗi ngày mà không nhận ra, trong Java, khi bạn truyền mộ object vào hàm, Java luôn ngầm định truyền dưới dạng tham chiếu (**rẻence - bản chất của con trỏ kiểu ẩn**). Go đi theo triêt lý minh bạch (explicit) nên chỉ yêu cầu bạn phải viết điều đó ra một cách rõ ràng.

# 1. Khái niệm cốt lõi: Ngôi nhà và Địa chỉ nhà
- Tưởng tuọng biến (variable) là một ngôi nhà
- Con trỏ chính là địa chỉ của ngôi nhà đó
    - Nếu tôi đưa cho bạn một tờ giấy photo ghi toàn bộ nội thất bên trong nhà (truyền giá trị), bạn có thể vẽ bậy lên đó nhưng ngôi nhà thật không bị ảnh hưởng
    - Nếu tôi đưa cho bạn địa chỉ nhà (truyền con trỏ) - bạn có thể lái xe tới và sơn lại màu tường cho căn nhà thật. 

# 2. Làm sao để nhớ Syntax: & và *

- Dấu "&" - có thể hiểu là "Địa chỉ của...", bạn dùng "&" để đặt trước một biến thông thường để lấy địa chỉ của nó.

```go
x := 10
pToX := &x // pointer to X = địa chỉ của x
```

- Dấu "*": Có 2 công dụng tuỳ vào vị trí đặt
    - Khi khai báo kiểu dữ liệu: "Con trỏ trỏ tới kiểu ..."
    ```go
    var p *int // p là một biến, có kiểu là "con trỏ trỏ tới kiểu int
    ```

    - Khi đặt trước một biến con trỏ: "Giá trị tại địa chỉ" - Dereferencing
    ```go
    fmt.Println(*pToX) // print giá trị tại địa chỉ x - (Kết quả: 10)
    *pToX = 20 // Đôi giá trị tại địa chỉ pToX thành 20
    ```

# 3 Tại sao lại cần con trỏ trong Golang?

Lý do lớn nhất là Go là ngôn ngữ "Call-by-value" (Truyền tham trị). Nghĩa là mỗi khi bạn cung cấp một biến cho một tham số của hàm, Go luôn tạo ra một bản copy giá trị của biến đó.

- Nếu bạn truyền một Struct User chứa rất nhiều data vào hàm, nó sẽ copy toàn bộ các trường của Struct đó. Hàm sẽ thao tác trên bản copy, bản gốc không hề bị đổi.
- Chỉ khi nào bạn muốn hàm có quyền THAY ĐỔI (mutate) bản gốc, bạn mới truyền con trỏ (*User).

# 4. So sánh với Java

```java
public void changeName(User u) {
    u.setName("Alice"); // u là tham chiếu, object gốc bên ngoài chắc chắn bị thay đổi.
}
```

```go
// Truyền giá trị (Giá trị gốc KHÔNG BỊ ĐỔI)
func changeNameFailed(u User) { 
    u.Name = "Alice" // Chỉ sửa trên bản copy
}

// Truyền con trỏ (Giá trị gốc SẼ BỊ ĐỔI) - Đây là cách hoạt động giống Java!
func changeNameSuccess(u *User) {
    u.Name = "Alice" // Sửa trực tiếp vào đối tượng thật
}
```

# 5. Những lưu ý khi sử dụng con trỏ
Hãy dùng con trỏ như một phương án cuối cùng" (Pointers Are a Last Resort).

- Hãy ưu tiên trả về Value (giá trị) thay vì Pointer (con trỏ): Nếu một hàm trả về con trỏ, dữ liệu đó sẽ bị lưu vào vùng nhớ Heap (thay vì Stack). Khi gọi hàm này nhiều lần trong vòng lặp, bạn tạo ra cực kỳ nhiều rác (garbage), làm Garbage Collector của Go phải hoạt động vất vả hơn và làm giảm tốc độ hệ thống.

- Dùng con trỏ khi:
1. Trạng thái của dữ liệu bắt buộc phải bị thay đổi bởi hàm.
2. Cần phân biệt giữa giá trị zero mặc định (ví dụ số 0) và việc "hoàn toàn không có dữ liệu" (nil), đặc biệt hữu dụng khi xử lý JSON null/optional field.

Dấu & là lấy chìa khóa nhà, dấu * là mở cửa vào nhà. Nắm vững điều này và bạn sẽ hoàn toàn làm chủ hệ thống vùng nhớ của Go!
