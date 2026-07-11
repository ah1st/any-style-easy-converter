import customtkinter as ctk
from tkinter import filedialog, messagebox
import subprocess
import os
import threading
import arabic_reshaper
from bidi.algorithm import get_display
from datetime import datetime

def reshape_text(text):
    return get_display(arabic_reshaper.reshape(text))

class AnyStyleConverter(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("AnyStyle Converter Pro")
        self.geometry("500x550")

        self.btn_select = ctk.CTkButton(self, text=reshape_text("اختر ملف المراجع"), command=self.select_file)
        self.btn_select.pack(pady=15)

        self.lbl_file = ctk.CTkLabel(self, text=reshape_text("لم يتم اختيار ملف"))
        self.lbl_file.pack(pady=5)

        self.format_var = ctk.StringVar(value="json")
        self.dropdown = ctk.CTkOptionMenu(self, variable=self.format_var, values=["json", "bib", "csl", "ris", "xml"])
        self.dropdown.pack(pady=10)

        self.btn_convert = ctk.CTkButton(self, text=reshape_text("بدء التحويل"), command=self.start_conversion_thread, fg_color="green")
        self.btn_convert.pack(pady=15)

        # شريط التقدم
        self.progress_bar = ctk.CTkProgressBar(self)
        self.progress_bar.set(0)
        self.progress_bar.pack(pady=10, padx=20, fill="x")

        self.log_textbox = ctk.CTkTextbox(self, height=120, width=450)
        self.log_textbox.pack(pady=10)
        self.log_textbox.configure(state="disabled")

        self.selected_file = None

    def log(self, message):
        self.log_textbox.configure(state="normal")
        self.log_textbox.insert("end", f"{reshape_text(message)}\n")
        self.log_textbox.see("end")
        self.log_textbox.configure(state="disabled")

    def select_file(self):
        self.selected_file = filedialog.askopenfilename()
        if self.selected_file:
            self.lbl_file.configure(text=reshape_text(os.path.basename(self.selected_file)))

    def start_conversion_thread(self):
        if not self.selected_file:
            messagebox.showwarning(reshape_text("تنبيه"), reshape_text("يرجى اختيار ملف أولاً"))
            return
        
        # فتح نافذة اختيار مكان الحفظ
        output_format = self.format_var.get()
        output_file = filedialog.asksaveasfilename(defaultextension=f".{output_format}", filetypes=[(f"{output_format} files", f"*.{output_format}")])
        
        if not output_file:
            return
            
        threading.Thread(target=self.convert_file, args=(output_file,), daemon=True).start()

    def convert_file(self, output_file):
        self.btn_convert.configure(state="disabled")
        self.progress_bar.set(0.1) # بداية
        
        try:
            self.log("جاري التحويل...")
            # تشغيل الأداة
            subprocess.run(["anystyle", "-f", os.path.splitext(output_file)[1][1:], "parse", self.selected_file, output_file], check=True)
            
            self.progress_bar.set(1.0) # اكتمال
            self.log("تم الحفظ بنجاح!")
            messagebox.showinfo(reshape_text("نجاح"), reshape_text("تم التحويل وحفظ الملف"))
        except Exception as e:
            self.log("خطأ في التحويل")
        finally:
            self.btn_convert.configure(state="normal")
            self.progress_bar.set(0)

if __name__ == "__main__":
    app = AnyStyleConverter()
    app.mainloop()