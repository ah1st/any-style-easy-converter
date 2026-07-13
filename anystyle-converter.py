import customtkinter as ctk
from tkinter import filedialog, messagebox
import subprocess
import os
import threading
import arabic_reshaper
from bidi.algorithm import get_display

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

        self.format_var = ctk.StringVar(value="bib")
        self.dropdown = ctk.CTkOptionMenu(self, variable=self.format_var, values=["json", "bib", "csl", "ris", "xml"])
        self.dropdown.pack(pady=10)

        self.btn_convert = ctk.CTkButton(self, text=reshape_text("بدء التحويل"), command=self.start_conversion_thread, fg_color="green")
        self.btn_convert.pack(pady=15)

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
        file_path = filedialog.askopenfilename()
        if file_path:
            self.selected_file = file_path
            self.lbl_file.configure(text=reshape_text(os.path.basename(file_path)))

    def start_conversion_thread(self):
        if not self.selected_file:
            messagebox.showwarning(reshape_text("تنبيه"), reshape_text("يرجى اختيار ملف أولاً"))
            return
        
        output_format = self.format_var.get()
        # نافذة الحفظ هنا ستحدد اسم "المجلد" الذي سيتم إنشاؤه
        output_file = filedialog.asksaveasfilename(title="اختر مكان واسم المجلد للحفظ")
        
        if not output_file:
            return
            
        threading.Thread(target=self.convert_file, args=(output_file, output_format), daemon=True).start()

    def convert_file(self, output_file, output_format):
        self.btn_convert.configure(state="disabled")
        self.progress_bar.set(0.1)
        self.log("جاري التحويل...")

        try:
            format_arg = "bibtex" if output_format == "bib" else output_format
            
            # جلب المسار الدقيق الذي حدده سكريبت run.sh
            anystyle_cmd = os.environ.get('ANYSTYLE_EXACT_PATH', 'anystyle')
            
            # نمرر المسار مباشرة ليقوم بإنشاء المجلد وبداخله الملف
            command_list = [anystyle_cmd, "-f", format_arg, "parse", self.selected_file, output_file]
            
            result = subprocess.run(
                command_list,
                capture_output=True,
                text=True,
                check=False
            )

            if result.returncode == 0:
                self.progress_bar.set(1.0)
                folder_name = os.path.basename(output_file)
                self.log(f"تم التحويل! تجد الملف داخل مجلد: {folder_name}")
                messagebox.showinfo(
                    reshape_text("نجاح"), 
                    reshape_text(f"تم إنشاء مجلد '{folder_name}' وبداخله الملف المحول بنجاح!")
                )
            else:
                error_msg = result.stderr if result.stderr else result.stdout
                self.log(f"فشل التحويل: {error_msg}")
                
        except FileNotFoundError:
            self.log("خطأ حرج: لم يتم العثور على أداة anystyle.")
        except Exception as e:
            self.log(f"حدث خطأ غير متوقع: {str(e)}")
        finally:
            self.btn_convert.configure(state="normal")
            self.progress_bar.set(0)

if __name__ == "__main__":
    app = AnyStyleConverter()
    app.mainloop()
