package com.sp.common;

import java.awt.image.BufferedImage;
import java.awt.image.renderable.ParameterBlock;
import java.io.File;

import javax.media.jai.JAI;
import javax.media.jai.RenderedOp;

import org.springframework.stereotype.Service;

@Service("imageManager")
public class ImageManager {
	/**
	 * 이미지의 폭(width)을 구하는 메소드
	 * 이미지 폭 및 높이를 구하기 위해서는  JAI(Java Advanced Imaging) 라이브러리 필요
	 *     메이븐 -> groupId: javax.media, artifactId : jai_codec, jai_core, version:1.1.3
	 * @param pathname	이미지 파일이름
	 * @return					이미지 폭
	 * 
	 */
	public int getImageWidth(String pathname) {
		int width=-1;
		
		File file = new File(pathname);
		if (! file.exists())
			return width;
		
		ParameterBlock pb=new ParameterBlock(); 
        pb.add(pathname); 
        RenderedOp rOp=JAI.create("fileload",pb); 

        BufferedImage bi=rOp.getAsBufferedImage(); 

        width = bi.getWidth(); 		
		
		return width;
	}
	
	/**
	 * 이미지의 높이(height)를 구하는 메소드
	 * @param pathname	이미지 파일명
	 * @return					이미지 높이
	 */
	public int getImageHeight(String pathname) {
		int height=-1;
		
		File file = new File(pathname);
		if (! file.exists())
			return height;
		
		ParameterBlock pb=new ParameterBlock(); 
        pb.add(pathname); 
        RenderedOp rOp=JAI.create("fileload",pb); 

        BufferedImage bi=rOp.getAsBufferedImage(); 

        height = bi.getHeight();		
		
		return height;
	}

}
