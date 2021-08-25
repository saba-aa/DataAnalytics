/* 

Sql Data Cleaning for the Nashville Housing Data

*/

--changing the date format




SELECT SaleDate, CONVERT (Date, SaleDate)
FROM Sqlproject.dbo.NashvilleHousing

UPDATE Sqlproject.dbo.NashvilleHousing
SET SaleDate= CONVERT (Date, SaleDate)


ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD SaleDateConverted Date

UPDATE Sqlproject.dbo.NashvilleHousing
SET SaleDateConverted =CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM Sqlproject.dbo.NashvilleHousing


--Populate the Property Address Data wherever null



SELECT *
FROM Sqlproject.dbo.NashvilleHousing
Where PropertyAddress is null

SELECT a.ParcelID ,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress )
From  Sqlproject.dbo.NashvilleHousing a
JOIN  Sqlproject.dbo.NashvilleHousing b
On a.ParcelID=b.ParcelID 
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


UPDATE a
SET a.PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
From  Sqlproject.dbo.NashvilleHousing a
JOIN  Sqlproject.dbo.NashvilleHousing b
On a.ParcelID =b.ParcelID 
And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




--Breaking down PropertyAddress into individual columns (Address, City)



SELECT *
FROM Sqlproject.dbo.NashvilleHousing

SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1)
FROM Sqlproject.dbo.NashvilleHousing

ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD PropertyAdd1 nvarchar(100)
UPDATE Sqlproject.dbo.NashvilleHousing
SET PropertyAdd1 = SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1)

SELECT  PropertyAddress, SUBSTRING(PropertyAddress, CHARINDEX( ',', PropertyAddress)+1 , LEN(PropertyAddress)) AS ConvertedAddress
FROM Sqlproject.dbo.NashvilleHousing

ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD PropertyAddCity nvarchar(100)
UPDATE Sqlproject.dbo.NashvilleHousing
SET PropertyAddCity = SUBSTRING(PropertyAddress, CHARINDEX( ',', PropertyAddress)+1 , LEN(PropertyAddress))




--Breaking Down owner Address into (Address, City, State)


SELECT PARSENAME(Replace(OwnerAddress, ',','.'),3),
PARSENAME(Replace(OwnerAddress, ',','.'),2),
PARSENAME(Replace(OwnerAddress, ',','.'),1)
FROM Sqlproject.dbo.NashvilleHousing


ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD OwnerAddress1 nvarchar(100)
UPDATE Sqlproject.dbo.NashvilleHousing
SET OwnerAddress1 = PARSENAME(Replace(OwnerAddress, ',','.'),3)
ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD OwnerAddressCity nvarchar(100)
UPDATE Sqlproject.dbo.NashvilleHousing
SET OwnerAddressCity = PARSENAME(Replace(OwnerAddress, ',','.'),2)
ALTER TABLE Sqlproject.dbo.NashvilleHousing
ADD OwnerAddressState nvarchar(100)
UPDATE Sqlproject.dbo.NashvilleHousing
SET OwnerAddressState = PARSENAME(Replace(OwnerAddress, ',','.'),1)







--Change Y and N to Yes and No in "Sold As Vacant" Field

SELECT SoldAsVacant 
FROM Sqlproject.dbo.NashvilleHousing

SELECT  DISTINCT SoldAsVacant, count(*) As TotalNumber
FROM Sqlproject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
Order by 2

UPDATE Sqlproject.dbo.NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant='Y' THEN 'Yes'
						WHEN SoldAsVacant='N' THEN 'No'
						ELSE SoldAsVacant
					END





--Remove Duplicates

With Row_num AS(
Select *,
	ROW_NUMBER() over (PARTITION BY ParcelID,
	PropertyAddress,
	LegalReference,
	SalePrice, 
	SaleDate ORDER BY UniqueID) as Row_num
FROM Sqlproject.dbo.NashvilleHousing
)
DELETE
FROM Row_num
where Row_num>1




--DELETE unused columns

ALTER TABLE Sqlproject.dbo.NashvilleHousing
DROP COLUMN SaleDate



