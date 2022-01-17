# WEB SOLUTION WITH WORDPRESS PROJECT 6

#### This project is written with Ubuntu 20.04 as the host machine and RHEL-8.4.0 as the remote server on AWS

I launched 2 instances on AWS where one will be the web server and the other is the database which is the setup on *3-tier architecture* which include client side, server side and the database, Then I created 3 10g volume on aws which I attached to a machine each.

**Launching and creating logical volume on webserver
![Screenshot from 2022-01-15 20-49-18](https://user-images.githubusercontent.com/80127136/149781596-6e6c6e14-14d3-400d-b407-166d01a57d08.png)

![Screenshot from 2022-01-15 21-03-18](https://user-images.githubusercontent.com/80127136/149781602-3768d889-03c4-4e67-85ad-ce65ba37720f.png)

![Screenshot from 2022-01-15 21-06-13](https://user-images.githubusercontent.com/80127136/149781611-7762a570-2969-4a3d-87b1-a63e934176b4.png)

![Screenshot from 2022-01-15 21-06-44](https://user-images.githubusercontent.com/80127136/149781624-0c23afda-6021-497f-bdf6-0146dc40e978.png)
![Screenshot from 2022-01-15 21-13-23](https://user-images.githubusercontent.com/80127136/149781631-b76a01c5-50e3-46ad-b2cc-4938f72d6647.png)

![Screenshot from 2022-01-17 10-54-29](https://user-images.githubusercontent.com/80127136/149781719-09015e8a-07c7-4ea4-ad32-93e21fcad9c0.png)
![Screenshot from 2022-01-17 11-00-01](https://user-images.githubusercontent.com/80127136/149781730-0a8f6e89-b01c-4afe-a1da-14f6f277965a.png)



**Update the `/etc/fstab` file and reloading daemon**

![Screenshot from 2022-01-17 11-11-23](https://user-images.githubusercontent.com/80127136/149781739-ea36c221-cbb2-4e44-9a51-ca8f730913f8.png)
![Screenshot from 2022-01-17 11-11-27](https://user-images.githubusercontent.com/80127136/149781993-f7958681-d675-46e7-9b85-ff3da7128ad3.png)
![Screenshot from 2022-01-17 11-14-20](https://user-images.githubusercontent.com/80127136/149782084-5ceb9249-c74c-495c-b6f8-041cedfe80b9.png)
![Screenshot from 2022-01-17 11-40-58](https://user-images.githubusercontent.com/80127136/149782120-e86f869b-881a-4317-af9d-24d19d6d579f.png)
![Screenshot from 2022-01-17 11-43-58](https://user-images.githubusercontent.com/80127136/149782155-4cca8405-53ea-405a-aa89-94782bd0a130.png)

**Prepare the Database Server, Creation Logical VOlume and Mounting on `/db` and `/var/log`**
![Screenshot from 2022-01-17 11-47-16](https://user-images.githubusercontent.com/80127136/149782413-61244328-ebf5-47c4-aa53-d8b556817d04.png)
![Screenshot from 2022-01-17 11-50-50](https://user-images.githubusercontent.com/80127136/149782428-fcb15c42-3e40-415f-989a-a85bb8a763e9.png)
![Screenshot from 2022-01-17 11-58-19](https://u![Screenshot from 2022-01-17 11-58-33](https://user-images.githubusercontent.com/80127136/149782464-4f20797b-551f-4568-9b62-d790fd01f569.png)
ser-images.githubusercontent.com/80127136/149782436-c82b54e5-e98f-47c8-8b51-d224e072264d.png)

**Installing Wordpress on Webserver and Dependencies**
![Screenshot from 2022-01-17 12-27-50](https://user-images.githubusercontent.com/80127136/149782837-05c57006-3f74-4ce9-996e-aa1b79e04fd5.png)
![Screenshot from 2022-01-17 12-29-48](https://user-images.githubusercontent.com/80127136/149782850-d1b6c4d6-246d-4d79-861a-3072b3c7b96d.png)
![Screenshot from 2022-01-17 12-31-03](https://user-images.githubusercontent.com/80127136/149782863-46e39dda-f157-4c37-a777-f98cccf093f4.png)
![Screenshot from 2022-01-17 12-31-42](https://user-images.githubusercontent.com/80127136/149782872-8d7551e0-3fe5-410a-9795-8bb36b7f4afb.png)
![Screenshot from 2022-01-17 12-32-28](https://user-images.githubusercontent.com/80127136/149782890-08d52e8a-341d-49cd-a02b-4deaabf6a1ce.png)
![Screenshot from 2022-01-17 12-34-46](https://user-images.githubusercontent.com/80127136/149782907-f95ce586-c656-415f-8a4e-029def4f6303.png)
![Screenshot from 2022-01-17 12-35-42](https://user-images.githubusercontent.com/80127136/149782924-be913415-4ac6-4570-ae28-0670cebc3137.png)
![Screenshot from 2022-01-17 12-38-35](https://user-images.githubusercontent.com/80127136/149782931-d654d3d1-e4d5-422e-aa66-356b2099ec9d.png)
![Screenshot from 2022-01-17 12-46-17](https://user-images.githubusercontent.com/80127136/149782946-ca3b0d79-28db-48e2-a9fa-1b20788c89e2.png)

**Installing `mysql` on the datebase server and configure to work with wordpress**
![Screenshot from 2022-01-17 12-18-32](https://user-images.githubusercontent.com/80127136/149783293-7b90b883-dcd9-41bb-bc48-61b34b29da1c.png)
![Screenshot from 2022-01-17 12-51-11](https://user-images.githubusercontent.com/80127136/149783321-03fbc7a7-c0cd-49f0-a94d-74888b99b81b.png)
![Screenshot from 2022-01-17 12-51-20](https://user-images.githubusercontent.com/80127136/149783328-358ed902-01b6-4c0d-bcf0-14220b2d34a5.png)
![Screenshot from 2022-01-17 12-55-03](https://user-images.githubusercontent.com/80127136/149783349-d387522b-8d3d-468a-ac71-fe6ffd67d783.png)

**Configure wordpress to work with mysql and connection to it**

![Screenshot from 2022-01-17 12-55-47](https://user-images.githubusercontent.com/80127136/149784199-9546283b-1fc0-40be-a27a-6be86065105d.png)
![Screenshot from 2022-01-17 13-33-19](https://user-images.githubusercontent.com/80127136/149784319-83779683-b50a-427f-b503-43ba95e9a43b.png)
![Screenshot from 2022-01-17 13-33-47](https://user-images.githubusercontent.com/80127136/149784375-47c69194-3ca5-4a2c-abed-7bd6462672b1.png)

**Accessing wordpress with browser**
![Screenshot from 2022-01-17 13-58-53](https://user-images.githubusercontent.com/80127136/149785063-f64731e6-d43a-4030-baf6-6a671fae19d1.png)
![Screenshot from 2022-01-17 14-00-53](https://user-images.githubusercontent.com/80127136/149785108-a6cc7521-8278-47c6-9ff6-29273d6e0b80.png)
![Screenshot from 2022-01-17 14-01-48](https://user-images.githubusercontent.com/80127136/149785168-42b147a9-6e83-443e-9961-52aa7f9eed2c.png)


Thank you,
Akinmoyero Gabriel































